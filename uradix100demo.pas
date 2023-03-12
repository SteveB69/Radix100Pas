unit uRadix100demo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TFormRadix100demo }

  TFormRadix100demo = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    edFloat: TEdit;
    edFloatP: TEdit;
    edFloatRes: TEdit;
    edFloatResP: TEdit;
    edHex: TEdit;
    edHexD: TEdit;
    edHexRes: TEdit;
    edDisp: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private

  public

  end;

var
  FormRadix100demo: TFormRadix100demo;

implementation

{$R *.lfm}

{ TFormRadix100demo }

uses uRadix100;

procedure TFormRadix100demo.BitBtn1Click(Sender: TObject);
var h,d : String;
    r : TRadix100;
    f : Extended;
begin
  h := trim(edHex.text);
  r := HexToRadix100(h);
  f := Radix100ToFloat(r);
  str(f:10,d);
  edHexRes.Text:=FloatToStr(f);
end;

procedure TFormRadix100demo.BitBtn2Click(Sender: TObject);
var h,d : String;
    r : TRadix100;
    f : Extended;
    rc : integer;
begin
  d := trim(edFloat.text);
  val(d,f,rc);
  if rc=0 then begin
    r := FloatToRadix100(f);
    h := Radix100ToHex(r);
    edFloatRes.text := h;
  end else ShowMessage(d+' is not a numeric value.');
end;

procedure TFormRadix100demo.BitBtn3Click(Sender: TObject);
var h,d : String;
    r : TRadix100;
begin
  h := trim(edHexD.text);
  r := HexToRadix100(h);
  d := Radix100ToDisplay(r);
  edDisp.Text:=d;
end;

procedure TFormRadix100demo.BitBtn4Click(Sender: TObject);
var h,d : String;
    r : TRadix100;
    f : Extended;
    rc : integer;
begin
  d := edFloatP.text;
  r := DisplayToRadix100(d);
  h := Radix100ToHex(r);
  edFloatResP.text := h;
end;

end.

