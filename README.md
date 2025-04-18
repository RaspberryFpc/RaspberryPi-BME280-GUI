
# BME280 Free Pascal Driver for Raspberry Pi

This is a Free Pascal driver for the BME280 sensor, which measures temperature, humidity, and air pressure. The driver supports both default and user-configured settings.

![Screenshot](https://github.com/RaspberryPiFpcHub/RaspberryPi-BME280-GUI/blob/main/BME280.png)

## 📄 Introduction

This driver provides functions for interacting with the BME280 sensor via I2C on the Raspberry Pi. It offers two initialization methods: one with default settings and one for user-defined configurations.

---

# BME280 Free Pascal Treiber für Raspberry Pi

Dies ist ein Free Pascal-Treiber für den BME280-Sensor, der Temperatur, Luftfeuchtigkeit und Luftdruck misst. Der Treiber unterstützt sowohl Standardeinstellungen als auch benutzerdefinierte Konfigurationen.

## 📄 Einführung

Dieser Treiber bietet Funktionen zur Interaktion mit dem BME280-Sensor über I2C auf dem Raspberry Pi. Es werden zwei Initialisierungsmethoden angeboten: eine mit Standardeinstellungen und eine für benutzerdefinierte Konfigurationen.

## 🛠️ Features

- Supports both I2C addresses `$76` and `$77`.
- Two initialization functions: one with default settings and one for custom configuration.
- All parameters are defined as constants for ease of use.
- Simple integration with Raspberry Pi (requires I2C enabled).

---

## 🛠️ Funktionen

- Unterstützt sowohl die I2C-Adressen `$76` als auch `$77`.
- Zwei Initialisierungsfunktionen: eine mit Standardeinstellungen und eine für benutzerdefinierte Konfiguration.
- Alle Parameter sind als Konstanten definiert, um die Verwendung zu erleichtern.
- Einfache Integration mit Raspberry Pi (erfordert aktiviertes I2C).

## 🧰 Installation

1. Enable I2C on your Raspberry Pi (run `sudo raspi-config`, then navigate to `Interfacing Options` → `I2C` and enable it).
2. Clone this repository:
   ```bash
   git clone https://github.com/RaspberryPiFpcHub/BME280-FreePascal-Driver.git
   ```
3. Add the `bme280.pas` file to your project.

---

## 🧰 Installation

1. Aktivieren Sie I2C auf Ihrem Raspberry Pi (führen Sie `sudo raspi-config` aus, navigieren Sie dann zu `Interfacing Options` → `I2C` und aktivieren Sie es).
2. Klonen Sie dieses Repository:
   ```bash
   git clone https://github.com/RaspberryPiFpcHub/BME280-FreePascal-Driver.git
   ```
3. Fügen Sie die Datei `bme280.pas` zu Ihrem Projekt hinzu.

## 📜 Vordefinierte Konstanten / Predefined Constants

Alle verfügbaren Parameter sind als Konstanten definiert, die im Programm verwendet werden können. Diese Konstanten ermöglichen eine einfache und verständliche Konfiguration der Sensorinitialisierung.

### **1. Modus / Mode**
| Konstantenname | Beschreibung (DE)                                   | Description (EN)                                  | Binärwert (Binary)     |
|----------------|-----------------------------------------------------|--------------------------------------------------|------------------------|
| `Sleepmode`    | Schlafmodus des Sensors                             | Sleep mode of the sensor                         | `%0`                   |
| `Forcedmode`   | Zwangsmodus (Sensor liest einmal und wechselt dann zurück in den Sleepmodus) | Forced mode (sensor reads once and then returns to sleep mode) | `%1`                   |
| `Normalmode`   | Normalmodus, kontinuierliche Messungen              | Normal mode, continuous measurements              | `%11`                  |

### **2. Oversampling**
| Konstantenname             | Beschreibung (DE)                                    | Description (EN)                                   | Binärwert (Binary)           |
|---------------------------|-----------------------------------------------------|---------------------------------------------------|------------------------------|
| `PressureOversampling1`    | Oversampling für Luftdruck (x1)                     | Pressure oversampling (x1)                        | `%00100`                     |
| `PressureOversampling2`    | Oversampling für Luftdruck (x2)                     | Pressure oversampling (x2)                        | `%01000`                     |
| `PressureOversampling4`    | Oversampling für Luftdruck (x4)                     | Pressure oversampling (x4)                        | `%01100`                     |
| `PressureOversampling8`    | Oversampling für Luftdruck (x8)                     | Pressure oversampling (x8)                        | `%10000`                     |
| `PressureOversampling16`   | Oversampling für Luftdruck (x16)                    | Pressure oversampling (x16)                       | `%10100`                     |
| `TemperatureOversampling1` | Oversampling für Temperatur (x1)                    | Temperature oversampling (x1)                     | `%00100000`                  |
| `TemperatureOversampling2` | Oversampling für Temperatur (x2)                    | Temperature oversampling (x2)                     | `%01000000`                  |
| `TemperatureOversampling4` | Oversampling für Temperatur (x4)                    | Temperature oversampling (x4)                     | `%01100000`                  |
| `TemperatureOversampling8` | Oversampling für Temperatur (x8)                    | Temperature oversampling (x8)                     | `%10000000`                  |
| `TemperatureOversampling16`| Oversampling für Temperatur (x16)                   | Temperature oversampling (x16)                    | `%10100000`                  |
| `HumidityOversampling1`    | Oversampling für Luftfeuchtigkeit (x1)              | Humidity oversampling (x1)                        | `0`                          |
| `HumidityOversampling2`    | Oversampling für Luftfeuchtigkeit (x2)              | Humidity oversampling (x2)                        | `1`                          |
| `HumidityOversampling4`    | Oversampling für Luftfeuchtigkeit (x4)              | Humidity oversampling (x4)                        | `2`                          |
| `HumidityOversampling8`    | Oversampling für Luftfeuchtigkeit (x8)              | Humidity oversampling (x8)                        | `3`                          |
| `HumidityOversampling16`   | Oversampling für Luftfeuchtigkeit (x16)             | Humidity oversampling (x16)                       | `4`                          |

### **3. Wiederholrate / Repeat Time**
| Konstantenname            | Beschreibung (DE)                                   | Description (EN)                                   | Binärwert (Binary)     |
|--------------------------|-----------------------------------------------------|---------------------------------------------------|------------------------|
| `Repeat0_5ms`            | Wiederholrate alle 0,5ms                           | Repeat time every 0.5ms                           | `%00000000`           |
| `Repeat_62_5ms`          | Wiederholrate alle 62,5ms                          | Repeat time every 62.5ms                          | `%00100000`           |
| `Repeat_125ms`           | Wiederholrate alle 125ms                           | Repeat time every 125ms                           | `%01000000`           |
| `Repeat_250ms`           | Wiederholrate alle 250ms                           | Repeat time every 250ms                           | `%01100000`           |
| `Repeat_500ms`           | Wiederholrate alle 500ms                           | Repeat time every 500ms                           | `%10000000`           |
| `Repeat_1000ms`          | Wiederholrate alle 1000ms                          | Repeat time every 1000ms                          | `%10100000`           |
| `Repeat_10ms`            | Wiederholrate alle 10ms                            | Repeat time every 10ms                            | `%11000000`           |
| `Repeat_20ms`            | Wiederholrate alle 20ms                            | Repeat time every 20ms                            | `%11100000`           |

### **4. Filter**
| Konstantenname           | Beschreibung (DE)                                   | Description (EN)                                   | Binärwert (Binary)     |
|-------------------------|-----------------------------------------------------|---------------------------------------------------|------------------------|
| `filterOff`              | Kein Filter                                         | No filter                                          | `%00000000`           |
| `filter2`                | Filterstufe 2                                        | Filter level 2                                     | `%00000100`           |
| `filter4`                | Filterstufe 4                                        | Filter level 4                                     | `%00001000`           |
| `filter8`                | Filterstufe 8                                        | Filter level 8                                     | `%00001100`           |
| `filter16`               | Filterstufe 16                                       | Filter level 16                                    | `%00010000`           |

### **5. SPI Enable**
| Konstantenname          | Beschreibung (DE)                                   | Description (EN)                                   | Binärwert (Binary)     |
|-------------------------|-----------------------------------------------------|---------------------------------------------------|------------------------|
| `EnableSPI`             | SPI aktivieren                                      | Enable SPI                                         | `00000001`             |

---

## ⚙️ Funktionen / Functions

### **1. Initbme280**

Initializes the BME280 sensor with user-defined configurations.

```pascal
function Initbme280(HumidityOversampling, PressureOversampling, TemperatureOversampling, mode, Repeattime, filter: byte): integer;
```

### **2. Initbme280_WithDefaults**

Initializes the BME280 sensor with default settings.

```pascal
function Initbme280_WithDefaults: integer;
```

---

## 🔒 Lizenz / License

```text
MIT License
Copyright (c) 2025 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is provided to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.
```

