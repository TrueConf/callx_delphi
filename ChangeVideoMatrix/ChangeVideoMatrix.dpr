program ChangeVideoMatrix;

uses
  Vcl.Forms,
  ChangeVideoMatrixForm in 'ChangeVideoMatrixForm.pas' {frmChangeVideoMatrix};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ChangeVideoMatrix';
  Application.CreateForm(TfrmChangeVideoMatrix, frmChangeVideoMatrix);
  Application.Run;
end.
