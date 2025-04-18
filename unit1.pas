unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin, bme280, DateUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnAktualisieren: TButton;
    Label1: TLabel;
    LabelTemp: TLabel;
    LabelHum: TLabel;
    LabelPres: TLabel;
    LabelDew: TLabel;
    Labelupdate: TLabel;
    SpinEditaltitude: TSpinEdit;
    Timer1: TTimer;
    //procedure btnAktualisierenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AktualisiereWerte;
  private
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

{ TForm1 }

var
  bme: integer;


procedure TForm1.FormCreate(Sender: TObject);
begin
  bme := Initbme280_WithDefaults;
  if bme < 0 then
  begin
    ShowMessage('BME280 konnte nicht initialisiert werden.');
    Halt;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if bme >= 0 then DeInizBme280(BME);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  AktualisiereWerte;
end;


function Dewpoint(Temperatur, RelativeFeuchte: single): single;
const
  a = 17.62;
  b = 243.12;
var
  alpha: single;
begin
  if (RelativeFeuchte <= 0) or (RelativeFeuchte > 100) then
  begin
    Result := 9999.9;
    Exit(-9999.9); // Ungültiger Bereich
  end;

  alpha := ln((RelativeFeuchte / 100) * exp((a * Temperatur) / (b + Temperatur)));
  Result := (b * alpha) / (a - alpha);
end;


procedure TForm1.AktualisiereWerte;
var
  temperature, humidity, pressure: double;
  dew: double;
begin
  if BME280ReadValues(SpinEditaltitude.Value, temperature, humidity, pressure) then    //with calculation for sealevel
  begin
    LabelTemp.Caption := 'Temperature: ' + FormatFloat('0.00', temperature) + ' °C';
    LabelHum.Caption := 'Humidity: ' + FormatFloat('0.00', humidity) + ' %';
    LabelPres.Caption := 'Pressure: ' + FormatFloat('0.00', pressure) + ' hPa';
    labelupdate.Caption := 'Last update: ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', Now);
    Dew := Dewpoint(temperature, humidity);
    LabelDew.Caption := 'Dewpoint: ' + FormatFloat('0.00', Dew) + ' °C';
  end
  else
  begin
    LabelTemp.Caption := 'Temperature: Error!';
    LabelHum.Caption := 'Humidity:Error!';
    LabelPres.Caption := 'Pressure: Error!';
    LabelDew.Caption := 'Dewpoint: Error!';
    labelupdate.Caption := 'Last update: Error';
  end;
end;

end.
