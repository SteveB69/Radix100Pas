unit uRadix100;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type TRadix100 = array[0..7] of byte;

function IsRadix100(r:TRadix100):boolean;
function IsRadix100(s: ShortString):boolean;
function IsPrintableRadix100(r:TRadix100):boolean;
function HexToRadix100(h:String):TRadix100;
function Radix100ToHex(r:TRadix100):string;
function StringToRadix100(s: ShortString): TRadix100;
function Radix100ToString(r:TRadix100):ShortString;
function FloatToRadix100(f:Extended):TRadix100;
function Radix100ToFloat(r:TRadix100):Extended;
function Radix100ToDisplay(r:TRadix100):String;
function DisplayToRadix100(s:String):TRadix100;


implementation

uses math;

function NybbleVal(s:string):integer;
var c : string[1];
begin
  if s<>'' then c := copy(s,1,1)
           else c := '0';
  Result := pos(c,'123456789ABCDEF');
end;


function IsRadix100(r: TRadix100): boolean;
var lw : LongWord;
    i  : integer;
    valid : boolean;
begin
  if r[0]>128 then begin    // if negative
    lw := r[0]*256+r[1];    // take the first word
    lw := $10000-lw;        // build the two's complement
    r[0] := (lw DIV 256);   // write hi-byte
    r[1] := (lw MOD 256);   // write lo-byte
  end;
  // now every value should be between 0 and 99
  valid := true;
  for i:=0 to 7 do if r[i]>99 then valid:=false;
  Result := valid;
end;


function IsRadix100(s: ShortString): boolean;
var r : TRadix100;
    i : integer;
begin
  Initialize(r);
  for i:=0 to min(7,length(s)-1) do r[i]:=ord(s[i+1]);
  Result := IsRadix100(r);
end;


function IsPrintableRadix100(r:TRadix100):boolean;
var b : boolean;
    i : integer;
begin
  b:=true;
  for i:=0 to 7 do if r[i]<32 then b:=false;
  Result := b;
end;


function StringToRadix100(s: ShortString): TRadix100;
var r : TRadix100;
    i : integer;
begin
  Initialize(r);
  for i:=0 to min(7,length(s)-1) do r[i]:=ord(s[i+1]);
  Result := r;
end;

function Radix100ToString(r:TRadix100):ShortString;
var s : ShortString;
    i : integer;
begin
  s:='';
  for i:=0 to 7 do s:=s+chr(r[i]);
  Result := s;
end;


function HexToRadix100(h: String): TRadix100;
var i:integer;
begin
  h:=uppercase(h);
  for i:=0 to 7 do begin
     Result[i]:=NybbleVal(copy(h,i*2+1,1))*16+NybbleVal(copy(h,i*2+2,1));
  end;
end;


function Radix100ToHex(r: TRadix100): string;
var i : integer;
    s : string;
begin
  s:='';
  for i:=0 to 7 do begin
    s := s + HexStr(r[i],2);
  end;
  Result := s;
end;


function FloatToRadix100(f: Extended): TRadix100;
var negative : boolean;
    expo,i : integer;
    ext : extended;
    lw  : LongWord;
    r   : TRadix100;
begin
  if f<0 then begin
    negative := true;
    f := -f;
  end else negative:=false;
  if f<>0 then ext := LogN(100,f) else ext:=0;
  expo:=trunc(ext);
  if ext<0 then dec(expo);   // trunc rounds to the absolute value
  ext := f / power(100,expo);
  for i:=1 to 7 do begin
     r[i]:= trunc(ext);
     ext := Frac(ext)*100;
  end;
  if f=0 then r[0]:=0 else r[0] := expo + $40;
  if negative then begin
    lw := r[0]*256+r[1];    // take the first word
    lw := $10000-lw;        // build the two's complement
    r[0] := (lw DIV 256);   // write hi-byte
    r[1] := (lw MOD 256);   // write lo-byte
  end;
  Result := r;
end;


function Radix100ToFloat(r: TRadix100): Extended;
var negative : boolean;
    expo,i : integer;
    ext : extended;
    lw  : LongWord;
begin
  if r[0]>=128 then begin    // if negative
    negative := true;
    lw := r[0]*256+r[1];    // take the first word
    lw := $10000-lw;        // build the two's complement
    r[0] := (lw DIV 256);   // write hi-byte
    r[1] := (lw MOD 256);   // write lo-byte
  end else negative:=false;
  expo := r[0] - $40;       // Exponent shifted by $40
  ext  := 0;
  for i:=1 to 7 do ext := ext + r[i]/100**(i-1);
  if negative then Result := -ext * power(100,Expo)
              else Result :=  ext * power(100,Expo);
end;


function Radix100ToDisplay(r: TRadix100): String;
var negative : boolean;
    expo,i : integer;
    lw  : LongWord;
    mant: String;
begin
  if r[0]>=128 then begin    // if negative
    negative := true;
    lw := r[0]*256+r[1];    // take the first word
    lw := $10000-lw;        // build the two's complement
    r[0] := (lw DIV 256);   // write hi-byte
    r[1] := (lw MOD 256);   // write lo-byte
  end else negative:=false;
  expo := (r[0] - $40) * 2; // from base 100 to base 10
  if r[1]=0 then expo:=0;   // special handling for 0
  if r[1]>9 then begin
    mant := IntToStr(r[1] DIV 10) + '.' + IntToStr(r[1] MOD 10);
    inc(expo);
  end else mant := IntToStr(r[1]) + '.';
  for i:=2 to 7 do mant := mant + IntToStr(r[i] DIV 10) + IntToStr(r[i] MOD 10);
  while (rightstr(mant,1)='0') and (length(mant)>3)
     do mant:=copy(mant,1,length(mant)-1); // no trailing zeros
  if negative then Result := '-' else Result := ' ';
  Result := Result + mant + 'E' + IntToStr(Expo);
  if rightstr(Result,2)='E0' then Result:=copy(Result,1,length(Result)-2);
end;


function DisplayToRadix100(s: String): TRadix100;
var negative : boolean;
    expo,i : integer;
    lw  : LongWord;
    mant,expstr: String;
    r : TRadix100;
begin
  s := trim(uppercase(s));
  if leftstr(s,1)='-' then negative := true
                      else negative := false;
  mant := '';
  expStr := '';
  expo := 0;
  i:=1;
  // skip leading zeros
  while (i<=length(s)) and (s[i] in ['0','-','+']) do inc(i);

  // read to the decimal point
  while (i<=length(s)) and (s[i] in ['0'..'9','-','+']) do begin
     if (s[i] in ['0'..'9']) then mant := mant + s[i];
     inc(i);
  end;
  expo := length(mant)-1;
  if (i<=length(s)) and (s[i]='.') then inc(i);
  // read fraction
  while (i<=length(s)) and (s[i] in ['0'..'9']) do begin
     if (s[i] in ['0'..'9']) then mant := mant + s[i];
     inc(i);
  end;
  // non scientific notation 0.000x
  while (length(mant)>1) and (leftstr(mant,1)='0') do begin
     mant := copy(mant,2,32);
     dec(expo);
  end;

  // check for exponent
  if (i<=length(s)) and (s[i]='E') then begin
    inc(i);
    // if it is negative?
    if (i<=length(s)) and (s[i]='-') then begin
      expstr := '-';
      inc(i);
    end;
    // and read to the end
    while (i<=length(s)) and (s[i] in ['0'..'9']) do begin
       if (s[i] in ['0'..'9']) then expstr := expstr + s[i];
       inc(i);
    end;
  end;

  // adjust the exponent
  expo := expo + StrToIntDef(expstr,0);

  // shift one digit if exponent is even
  if not odd(expo) then mant := '0' + mant;

  // now transfer the mantisse to radix-100 byte 1 to 7
  mant := mant + '000000000000000000'; // make sure mantisse is long enough
  for i:=1 to 7 do r[i]:=StrToInt(copy(mant,2*i-1,2));

  // covert base 10 to base 100
  if expo<0 then dec(expo); // rounding strange on negative numbers
  expo := (expo DIV 2);
  if r[1]=0 then r[0] := 0  // special def. for zero
            else r[0] := expo + $40;
  if negative then begin
    lw   := r[0]*256+r[1];  // take the first word
    lw   := $10000-lw;      // build the two's complement
    r[0] := (lw DIV 256);   // write hi-byte
    r[1] := (lw MOD 256);   // write lo-byte
  end;

  Result := r;
end;

end.

