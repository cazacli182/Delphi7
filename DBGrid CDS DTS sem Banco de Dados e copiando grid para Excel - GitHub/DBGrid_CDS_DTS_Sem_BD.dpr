program DBGrid_CDS_DTS_Sem_BD;

uses
  Forms,
  untPrincipal in 'untPrincipal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
