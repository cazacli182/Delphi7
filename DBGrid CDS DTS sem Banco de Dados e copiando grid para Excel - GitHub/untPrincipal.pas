unit untPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, DBClient, StdCtrls, ExtCtrls, ClipBrd;

type
  TForm1 = class(TForm)
    DTS: TDataSource;
    CDS: TClientDataSet;
    CDSnome: TStringField;
    CDSidade: TIntegerField;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure CopiarHtml;
    procedure CopyHTMLToClipBoard(const str: ansistring; const htmlStr: ansistring = '');
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CopiarHtml;
var
  Linhas, Header: AnsiString;
  i: integer;
  
begin
  Linhas:= '<tr><td bgcolor="Yellow"><B><font color="red">Nome</font><B/></td>' +
               '<td bgcolor="Yellow"><B><font color="red">Idade</font><B/></td></tr>';

  if Linhas <> '' then Linhas := Linhas + #13;

  CDS.First;
  while not CDS.Eof do
  begin
    Linhas := Linhas + '<tr><td>' + CDS.FieldByName('nome').AsString  + '</td>' +    //Nome
                           '<td>' + CDS.FieldByName('idade').AsString + '</td></tr>';//Idade
    CDS.Next;
  end;

  Header:= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
  {$IFDEF FPC THEN}
  Header:= Header + #13 + '<meta charset="UTF-8">';
  {$ELSE}
   Header:= Header + #13 + '<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1">';
  {$ENDIF}

  Linhas:= '<table style="width:100%">' + #13 + Linhas;
  Linhas:= Linhas + '</table>';
  Linhas:= Header + Linhas;

  CopyHTMLToClipBoard(Linhas,linhas);
end;

procedure TForm1.CopyHTMLToClipBoard(const str: ansistring; const htmlStr: ansistring = '');
var
  gMem: HGLOBAL;
  lp: PChar;
  Strings: array[0..1] of ansistring;
  Formats: array[0..1] of UINT;
  i: integer;

  function FormatHTMLClipboardHeader(HTMLText: string): string;
  const
    CrLf = #13#10;
  begin
    Result:= 'Version:0.9' + CrLf;
    Result:= Result + 'StartHTML:-1' + CrLf;
    Result:= Result + 'EndHTML:-1' + CrLf;
    Result:= Result + 'StartFragment:000081' + CrLf;
    Result:= Result + 'EndFragment:°°°°°°' + CrLf;
    Result:= Result + HTMLText + CrLf;
    Result:= StringReplace(Result, '°°°°°°', Format('%.6d', [Length(Result)]), []);
  end;

begin
  gMem:= 0;
  {$IFNDEF USEVCLCLIPBOARD}
  Win32Check(OpenClipBoard(0));
  {$ENDIF}
  try
    //most descriptive first as per api docs
    Strings[0]:= FormatHTMLClipboardHeader(htmlStr);
    Strings[1]:= str;
    Formats[0]:= RegisterClipboardFormat('HTML Format');
    Formats[1]:= CF_TEXT;
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(EmptyClipBoard);
    {$ENDIF}
    for i:= 0 to High(Strings) do
    begin
      if Strings[i] = '' then Continue;
      //an extra "1" for the null terminator
      gMem:= GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, Length(Strings[i]) + 1);
      {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp:= GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, PChar(Strings[i]), Length(Strings[i]) + 1);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(Formats[i], gMEm);
      Win32Check(gmem <> 0);
      gmem:= 0;
    end;
  finally
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(CloseClipBoard);
    {$ENDIF}
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
  ListaNomes:  array[1..5] of String;  {ou inicializar já carregado... como no exemplo abaixo:}
  ListaIdades: array[1..5] of Integer; {ou inicializar já carregado: array[1..5] of Integer = (33, 22, 7, 1, 60);}

begin
  CDS.Close;
  {Preencho os array's com os valores para as 5 posições}
  for i := 1 to 5 do
  begin
    case i of
      1:
        begin
          ListaNomes[i] := 'Charles';
          ListaIdades[i]:= 33;
        end;
      2:
        begin
          ListaNomes[i] := 'Maria';
          ListaIdades[i]:= 32;
        end;
      3:
        begin
          ListaNomes[i] := 'Liliane';
          ListaIdades[i]:= 17;
        end;
      4:
        begin
          ListaNomes[i] := 'Joao';
          ListaIdades[i]:= 15;
        end;
      5:
        begin
          ListaNomes[i] := 'Paulo';
          ListaIdades[i]:= 60;
        end;
    end;
  end;

  CDS.CreateDataSet;

  for i := 1 to 5 do
  begin
    CDS.Append;
    CDS.FieldByName('nome').AsString  := ListaNomes[i];
    CDS.FieldByName('idade').AsInteger:= ListaIdades[i];
    CDS.Post;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CopiarHtml;
  ShowMessage('Conteúdo do Grid copiado para Clipboard. CTRL + V direto no Excel!')
end;

end.