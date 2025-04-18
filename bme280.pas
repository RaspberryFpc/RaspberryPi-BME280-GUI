unit BME280;

{$mode ObjFPC}{$H+}

interface

uses
  SysUtils, BaseUnix,math;

const
  I2C_SLAVE = 1795;
  DevAddr = $76;  // oder wahlweise $77 durch hardwareconfig
  devpath = '/dev/i2c-1';

  Reg_Reset = $E0;
  BMP280Reset = $B6;

  Reg_Status = $F3;
  measuring = %1000;
  in_update = %1;

  Reg_control_mess = $F4;
  Sleepmode = %0;
  Forcedmode = %1;
  Normalmode = %11;
  PressureOversampling1 = %00100;
  PressureOversampling2 = %01000;
  PressureOversampling4 = %01100;
  PressureOversampling8 = %10000;
  PressureOversampling16 = %10100;
  TemperatureOversampling1 = %00100000;
  TemperatureOversampling2 = %01000000;
  TemperatureOversampling4 = %01100000;
  TemperatureOversampling8 = %10000000;
  TemperatureOversampling16 = %10100000;
  HumidityOversampling1 = 0;
  HumidityOversampling2 = 1;
  HumidityOversampling4 = 2;
  HumidityOversampling8 = 3;
  HumidityOversampling16 = 4;

  Reg_config = $F5;

  EnableSPI = 00000001;

  Repeat0_5ms = %00000000;
  Repeat_62_5ms = %00100000;
  Repeat_125ms = %01000000;
  Repeat_250ms = %01100000;
  Repeat_500ms = %10000000;
  Repeat_1000ms = %10100000;
  Repeat_10ms = %11000000;
  Repeat_20ms = %11100000;

  filterOff = %00000000;
  filter2 = %00000100;
  filter4 = %00001000;
  filter8 = %00001100;
  filter16 = %00010000;


type
  CompensationTable = record
    dig_t1: word;
    dig_t2: smallint;  //16bit
    dig_t3: smallint;
    dig_P1: word;      //16bit
    dig_P2: smallint;
    dig_P3: smallint;
    dig_P4: smallint;
    dig_P5: smallint;
    dig_P6: smallint;
    dig_P7: smallint;
    dig_P8: smallint;
    dig_P9: smallint;
  end;

  HumCompensationTable = record
    dig_H1: byte;
    dig_H2: smallint;
    dig_H3: byte;
    dig_H4: smallint;
    dig_H5: smallint;
    dig_H6: shortint; //8bit
  end;

var
  i2c_fehlernummer: byte;
  Bme280_handle: integer;
  T_Fine: single;
  corr: CompensationTable;
  humcor: HumCompensationTable;

function BME280ReadValues(altitude: integer; var temperature, humidity, pressure: double): boolean;
function Initbme280(HumidityOversampling, PressureOversampling, TemperaturOversampling, mode, Repeattime, filter: byte): integer;
function Initbme280_WithDefaults: integer;
procedure DeInizBme280(BME280_Handle: integer);

implementation

function ReadRegister(DevHandle, StartRegister: integer; Readbuf: pchar; Count: integer): integer;
var
  written: integer;
begin
  if DevHandle < 1 then
  begin
    Result := -1;
    exit;
  end;
  written := fpwrite(DevHandle, Startregister, 1);
  if written <> 1 then
  begin
    Result := -1;
    //    ShowMessage('I2C  Fileposition konnte nicht gesetzt werden');
    i2c_fehlernummer.Bits[0] := True;
    exit;
  end;
  i2c_fehlernummer.Bits[0] := False;

  Result := fpread(DevHandle, ReadBuf, Count);
  if Result <> Count then
  begin
    Result := -1;
    //    ShowMessage('I2C ' + IntToStr(startregister) + ' Es konnten nicht alle Bytes gelesen werden');
    i2c_fehlernummer.Bits[1] := True;
    exit;
  end;
  i2c_fehlernummer.Bits[1] := False;
end;


function WriteRegister(DevHandle: integer; regno: byte; Data: byte): boolean;
var
  bu: array[0..1] of byte;
  written: integer;
begin
  bu[0] := regno;
  bu[1] := Data;
  written := fpwrite(DevHandle, bu, 2);   // wenn bit 7 nicht gesetzt dann schreiben
  if written > 0 then Result := True
  else
  begin
    //    ShowMessage('I2C Es konnte nicht geschrieben werden');
    Result := False;
    i2c_fehlernummer.Bits[2] := True;
    exit;
  end;
  i2c_fehlernummer.Bits[2] := False;
end;


function Initbme280(HumidityOversampling, PressureOversampling, TemperaturOversampling, mode, Repeattime, filter: byte): integer;
var
  iio: integer;
  buf: byte;
  e4_e6: array[0..2] of byte;
  ctrl_hum0xF2, ctrl_meas0xF4, config0xF5: byte;

begin
  ctrl_hum0xF2 := HumidityOversampling;
  ctrl_meas0xF4 := PressureOversampling or TemperaturOversampling or mode;
  config0xF5 := RepeatTime or filter;

  // Filehandle holen
  Result := -1;
  BME280_Handle := fpopen(devpath, O_RDWR);
  Result := BME280_Handle;
  if BME280_Handle < 0 then exit;

  iio := FpIOCtl(BME280_Handle, I2C_SLAVE, pointer(DevAddr));    //Set options
  if iio <> 0 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;
  // teste auf existenz
  if (ReadRegister(BME280_Handle, $D0, @buf, 1) <> 1) or (buf <> $60) then   //chipid
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  //Transfer Device Settings
  if not WriteRegister(BME280_Handle, $F5, config0xF5) then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  if not Writeregister(BME280_Handle, $F2, ctrl_hum0xF2) then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  if not Writeregister(BME280_Handle, $F4, ctrl_meas0xF4) then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;


  // Read Correctionparameter
  if ReadRegister(BME280_Handle, $88, @Corr, 24) <> 24 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  if ReadRegister(BME280_Handle, $A1, @HumCor.dig_H1, 1) <> 1 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  if ReadRegister(BME280_Handle, $E1, @HumCor.dig_H2, 3) <> 3 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;


  if ReadRegister(BME280_Handle, $E7, @HumCor.dig_H6, 2) <> 2 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;

  if ReadRegister(BME280_Handle, $E4, @e4_e6, 3) <> 3 then
  begin
    Fpclose(BME280_Handle);
    BME280_Handle := -1;
    exit;
  end;
  humcor.dig_h4 := (e4_e6[0] << 4) + (e4_e6[1] and $0F);
  humcor.dig_h5 := (e4_e6[2] << 4) + (e4_e6[1] >> 4);
  Result := BME280_Handle;
end;


function Initbme280_WithDefaults: integer;
begin
  Result := Initbme280(HumidityOversampling4, PressureOversampling4, TemperatureOversampling4, Normalmode, Repeat_250ms, filter4);
end;


 function CalculatePressureAtSeaLevel(p: Double; h: Double): Double;
const
  T0 = 288.15; // Standard-Temperatur auf Meereshöhe in Kelvin
  L = 0.0065;  // Temperaturgradient in K/m
  g = 9.80665; // Erdbeschleunigung in m/s²
  R = 8.31447; // Gaskonstante in J/(mol·K)
  M = 0.0289644; // Molarmasse der Luft in kg/mol
begin
  // Berechnung des Luftdrucks auf Meereshöhe
  Result := p * Power(1 - (L * h) / T0, -(g * M) / (R * L));
end;

var
  T, P: integer;
  H: int16;
  var1, var2: double;
  Values: array[0..7] of byte;
  press,Humid: double;
  Alt_Cor: double;
function BME280ReadValues(altitude: integer; var temperature, humidity, pressure: double): boolean;

begin
  Result := False;
  if BME280_Handle < 1 then
  begin
    exit;
  end;
  if ReadRegister(BME280_Handle, $F7, @Values, 8) <> 8 then
  begin
    exit;
  end;
  // tausche Bytes
  P := values[0] << 12 + values[1] << 4 + values[2] >> 4;
  T := values[3] << 12 + values[4] << 4 + values[5] >> 4;
  H := values[6] << 8 + values[7];

  // Testvalues
  //with CorValues do
  //    begin
  //      dig_t1:=27504;
  //      dig_t2:=26435;
  //      dig_t3:=-1000;
  //      dig_p1:= 36477;
  //      dig_p2:=-10685;
  //      dig_p3:= 3024;
  //      dig_p4:= 2855;
  //      dig_p5:= 140;
  //      dig_p6:= -7;
  //      dig_p7:= 15500;
  //      dig_p8:= -14600;
  //      dig_p9:= 6000;
  //      T_Fine:= 0;
  //    end;
  //temp:= 519888;
  //press:= 415148;

  var1 := (T / 16384 - Corr.dig_t1 / 1024) * Corr.dig_t2;
  var2 := (T / 131072 - Corr.dig_T1 / 8192) * (T / 131072 - Corr.dig_t1 / 8192) * Corr.dig_t3;
  T_Fine := var1 + var2;
  temperature := T_Fine / 5120;

  // Calculate Pressure
  // Berechnung Druck
  var1 := T_Fine / 2 - 64000;
  var2 := var1 * var1 * Corr.dig_P6 / 32768;
  var2 := var2 + var1 * Corr.dig_P5 / 2;
  var2 := var2 / 4 + Corr.dig_p4 * 65536;
  var1 := (Corr.dig_P3 * var1 * var1 / 524288 + Corr.dig_P2 * var1) / 524288;
  var1 := (1 + (var1 / 32768)) * Corr.dig_P1;

  pressure := 1048576 - p;
  pressure := (pressure - (var2 / 4096)) * 6250 / var1;
  var1 := Corr.dig_P9 * pressure * pressure / 2147483648;
  var2 := Pressure * Corr.dig_P8 / 32768;
  pressure := (pressure + (var1 + var2 + Corr.dig_P7) / 16)/100;
  pressure := CalculatePressureAtSeaLevel(pressure,altitude);

  // Calculate Humidity
  Humid := t_fine - 76800;
  Humid := (H - (humcor.dig_H4 * 64 + humcor.dig_H5 / 16384 * Humid)) * (humcor.dig_H2 / 65536 * (1 + humcor.dig_H6 / 67108864 * Humid * (1 + humcor.dig_H3 / 67108864 * Humid)));
  Humid := Humid * (1 - (humcor.dig_H1) * Humid / 524288.0);
  if Humid > 100 then Humid := 100;
  if Humid < 0 then Humid := 0;
  humidity := Humid;
  Result := True;
end;

procedure DeInizBme280(BME280_Handle: integer);
begin
  fpclose(BME280_Handle);
end;


end.
