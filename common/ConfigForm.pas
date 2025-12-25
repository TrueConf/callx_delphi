unit ConfigForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, TrueConf_CallXLib_TLB,
  Vcl.Imaging.pngimage, Vcl.Samples.Spin;

type
  TCallToType = (ctUser, ctUsersList, ctAB);

  TCallXSettings = record
    sServer: string;
    sUser: string;
    sPassword: string;
    bWriteLog: boolean;
  end;

  TfrmConfigurator = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnHardware: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    edServer: TEdit;
    Label9: TLabel;
    edUser: TEdit;
    Label10: TLabel;
    edPassword: TEdit;
    Label11: TLabel;
    edConfirmPassword: TEdit;
    ActionList: TActionList;
    actHardware: TAction;
    chbWriteLog: TCheckBox;
    btnShowLogFile: TButton;
    OpenVideoDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
    procedure actHardwareExecute(Sender: TObject);
    procedure actHardwareUpdate(Sender: TObject);
    procedure btnShowLogFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCallX: TTrueConfCallX;
    FMarkupConfig: TCallXSettings;
  protected
    function Check: boolean;
    procedure Save;
  public
    { Public declarations }
    class function GetRegKey: string;
    class procedure SaveSettings(AMarkupConfig: TCallXSettings);
    class procedure LoadSettings(var AMarkupConfig: TCallXSettings);
  public
    property CallX: TTrueConfCallX read FCallX write FCallX;
  end;

  function ShowConfigurator(ACallX: TTrueConfCallX): boolean;

implementation

uses Registry, rcstrings, HardwareForm, LogUnit, ShellApi;

{$R *.dfm}

const
  sREG_SERVER = 'Server';
  sREG_USER = 'User';
  sREG_PASSWORD = 'Password';
  sREG_CALL_TO_TYPE = 'Call to type';
  sREG_CALL_TO = 'Call to';
  sREG_NOTIFY_MANAGER = 'Notify manager';
  sREG_MANAGER = 'Manager';
  sREG_WRITE_LOG = 'Write log';

procedure TfrmConfigurator.actHardwareExecute(Sender: TObject);
begin
  if TfrmHardware.ShowDialog(self, GetRegKey, FCallX) then
  begin

  end;
end;

procedure TfrmConfigurator.actHardwareUpdate(Sender: TObject);
begin
  actHardware.Enabled := Assigned(FCallX);
  btnShowLogFile.Visible := Assigned(FCallX);
end;

procedure TfrmConfigurator.actOKExecute(Sender: TObject);
begin
  if not Check then
    Exit;

  { save to reg }
  Save;
  { close }
  ModalResult := mrOk;
  //Close;
end;

procedure TfrmConfigurator.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfigurator.btnShowLogFileClick(Sender: TObject);
var pcPath: PChar;
begin
  pcPath := PChar(GetLogPath);
  ShellExecute(Handle, nil, pcPath, nil, nil, SW_SHOWNORMAL);
end;

function TfrmConfigurator.Check: boolean;
begin
  Result := False;
  if Trim(edUser.Text) = '' then
  begin
    MessageDlg(sERROR_EMPTY_USER, mtError, [mbOK], 0);
    PageControl.ActivePageIndex := 0;
    if edUser.CanFocus then
      edUser.SetFocus;

    Exit;
  end
  else if edPassword.Text <> edConfirmPassword.Text then
  begin
    MessageDlg(sERROR_PASSWORDS_DO_NOT_MATCH, mtError, [mbOK], 0);
    PageControl.ActivePageIndex := 0;
    if edPassword.CanFocus then
      edPassword.SetFocus;

    Exit;
  end
  else if Trim(edPassword.Text) = '' then
  begin
    MessageDlg(sERROR_EMPTY_PASSWORD, mtError, [mbOK], 0);
    PageControl.ActivePageIndex := 0;
    if edPassword.CanFocus then
      edPassword.SetFocus;

    Exit;
  end;

  Result := True;
end;

procedure TfrmConfigurator.FormClose(Sender: TObject; var Action: TCloseAction);
var FullProgPath: PAnsiChar;
begin
  if ModalResult = mrOk then
  begin
    MessageDlg(Format('Application "%s" will restart', [Application.Title]), mtInformation, [mbOK], 0);
    { Restart the application }
    FullProgPath := PAnsiChar(AnsiString(Application.ExeName));
    WinExec(FullProgPath, SW_SHOW);
    Application.Terminate;
  end;
end;

procedure TfrmConfigurator.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  PageControl.ActivePageIndex := 0;

  LoadSettings(FMarkupConfig);

  edServer.Text := FMarkupConfig.sServer;
  edUser.Text := FMarkupConfig.sUser;
  edPassword.Text := FMarkupConfig.sPassword;
  edConfirmPassword.Text := FMarkupConfig.sPassword;

  chbWriteLog.Checked := FMarkupConfig.bWriteLog;
end;

class function TfrmConfigurator.GetRegKey: string;
begin
  Result := 'SOFTWARE\TrueConf\CallX_Examples\' + Application.ExeName;
end;

class procedure TfrmConfigurator.LoadSettings(var AMarkupConfig: TCallXSettings);
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey(GetRegKey, False) then
    begin
      if ValueExists(sREG_SERVER) then
        AMarkupConfig.sServer := ReadString(sREG_SERVER);
      if ValueExists(sREG_USER) then
        AMarkupConfig.sUser := ReadString(sREG_USER);
      if ValueExists(sREG_PASSWORD) then
        AMarkupConfig.sPassword := ReadString(sREG_PASSWORD);

      AMarkupConfig.bWriteLog := True;
      if ValueExists(sREG_WRITE_LOG) then
        AMarkupConfig.bWriteLog := ReadBool(sREG_WRITE_LOG);
    end;
  finally
    Free;
  end;
end;

procedure TfrmConfigurator.Save;
begin
  FMarkupConfig.sServer := edServer.Text;
  FMarkupConfig.sUser := edUser.Text;
  FMarkupConfig.sPassword := edPassword.Text;

  FMarkupConfig.bWriteLog := chbWriteLog.Checked;

  SaveSettings(FMarkupConfig);
end;

class procedure TfrmConfigurator.SaveSettings(AMarkupConfig: TCallXSettings);
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey(GetRegKey, True) then
    begin
      WriteString(sREG_SERVER, AMarkupConfig.sServer);
      WriteString(sREG_USER, AMarkupConfig.sUser);
      WriteString(sREG_PASSWORD, AMarkupConfig.sPassword);

      WriteBool(sREG_WRITE_LOG, AMarkupConfig.bWriteLog);
    end;
  finally
    Free;
  end;
end;

function ShowConfigurator(ACallX: TTrueConfCallX): boolean;
var FullProgPath: PAnsiChar;
begin
  Result := False;
  with TfrmConfigurator.Create(Application) do
  begin
    CallX := ACallX;
    { Show modal }
    Result := (ShowModal = mrOk);
  end;
end;

end.
