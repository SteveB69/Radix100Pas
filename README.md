# Radix100Pas
 A Unit to use [Radix-100](https://www.ninerpedia.org/wiki/Radix-100) encoded 8 byte numbers in Pascal 

## Usage

The unit uRadix100.pas pay be used with Free Pascal and Lazarus, or any other modern Pascal. It uses an eight byte array for storing Radix-100 encoded floating-point values.

**type TRadix100 = array[0..7] of byte;**


It provides the following functions:

* **function IsRadix100(r:TRadix100):boolean;**    // checks if **r** is a valid Radix-100 number
* **function HexToRadix100(h:String):TRadix100;**    // reads a hex-string into the Radix-100 format
* **function Radix100ToHex(r:TRadix100):string;**    // converts the encoded Radix-100 into a hex string
* **function Radix100ToFloat(r:TRadix100):Extended;**   // converts a Radix-100 value to Pascal *Extended* 
* **function FloatToRadix100(f:Extended):TRadix100;**  // converts a Pascal *Extended* value to Radix-100
* **function Radix100ToDisplay(r:TRadix100):String;**   // converts a Radix-100 value into a readable scientific notation
* **function DisplayToRadix100(s:String):TRadix100;**   // converts a readable scientific notation value into a Radix-100 

Use the *float* conversions if you want to do calculations and the *Display* conversions if you want to present or edit the values. The mapping of Radix-100 to modern *float* types is not 100% accurate. A value 0.12 may get 0.11999999999 in the other format. The *Display* conversion does only 

## Demo

The included Win64 Demo program Radix100demo offers a conversion Hex <-> Radix-100 via Float and via Text/Display. This might be used to as a stand-alone conversion application.


## Licence

This code is licenced under the BSD 3.0 licence and comes without any warrenty. Please let me know when you find an error. The code has been tested against the examples of the Texas Instruments Editor/Assembler Manual Page 279 and other examples, but errors may still occur.

!(https://github.com/SteveB69/Radix100Pas/blob/main/Radix100demo.png)