unit ChangeVideoMatrixForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, TrueConf_CallXLib_TLB,
  Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.Menus, ConfigForm, UserCacheUnit,
  CallX_Common, HardwareForm, Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList;

const
  TITLE = 'ChangeVideoMatrix Demo';

type
  TfrmChangeVideoMatrix = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    CallX: TTrueConfCallX;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    miExit: TMenuItem;
    miTools: TMenuItem;
    miConnectionSetting: TMenuItem;
    miHardwareSetting: TMenuItem;
    ActionList: TActionList;
    actCall: TAction;
    actHangUp: TAction;
    memoLog: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    lbParticipants: TListBox;
    Panel2: TPanel;
    Button1: TButton;
    actShakeUp: TAction;
    rgMatrixType: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure CallXInviteReceived(ASender: TObject;
      const eventDetails: WideString);
    procedure miExitClick(Sender: TObject);
    procedure CallXXAfterStart(Sender: TObject);
    procedure miConnectionSettingClick(Sender: TObject);
    procedure miHardwareSettingClick(Sender: TObject);
    procedure CallXChangeVideoMatrixReport(ASender: TObject;
      const eventDetails: WideString);
    procedure CallXXChangeState(ASender: TObject; prevState, newState: Integer);
    procedure CallXServerConnected(ASender: TObject;
      const eventDetails: WideString);
    procedure FormDestroy(Sender: TObject);
    procedure CallXUpdateParticipantList(ASender: TObject;
      const eventDetails: WideString);
    procedure actShakeUpUpdate(Sender: TObject);
    procedure actShakeUpExecute(Sender: TObject);
    procedure CallXXError(ASender: TObject; errorCode: Integer;
      const errorMsg: WideString);
  private
    { Private declarations }
    // server, call_id, password and others...
    FCallXSettings: TCallXSettings;
    // TrueConf CallX has already started working
    FStarted: boolean;
    // current authorized user status
    FStatus: TMyStatus;
  protected
    procedure WriteLog(ALine: string);
  public
    { Public declarations }
  end;

var
  frmChangeVideoMatrix: TfrmChangeVideoMatrix;

implementation

{$R *.dfm}

uses LogUnit;

{ OnXAfterStart event handler }
{ When CallX component is succesfully started }
{ I recommend set the hardware ((camera, microphone, speakers))
  in this event handler }
procedure TfrmChangeVideoMatrix.CallXXAfterStart(Sender: TObject);
begin
  WriteLog('OnXAfterStart: ==============================================');

  if (FCallXSettings.sServer <> '') or ((FCallXSettings.sUser <> '') and (FCallXSettings.sPassword <> '')) then
    CallX.connectToServer(FCallXSettings.sServer)
  else
    WriteLog('Empty connect & login info');

  if TfrmHardware.ApplySettings(self, TfrmConfigurator.GetRegKey, CallX) then
  begin

  end;

  FStarted := True;

  miConnectionSetting.Enabled := True;
  miHardwareSetting.Enabled := True;
end;

procedure TfrmChangeVideoMatrix.CallXXChangeState(ASender: TObject; prevState,
  newState: Integer);
begin
  FStatus := IntToMyStatus(newState);
  Caption := Format('%s. Authorized user: %s [%s]', [TITLE, FCallXSettings.sUser, IntToMyStringState(newState)]);
end;

procedure TfrmChangeVideoMatrix.CallXXError(ASender: TObject;
  errorCode: Integer; const errorMsg: WideString);
begin
  WriteLog('OnXError: ' + errorMsg);
end;

procedure TfrmChangeVideoMatrix.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  FStatus := csBeforeInit;
  Caption := TITLE + ' [connecting...]';

  { Get settings: server, call_id, password }
  TfrmConfigurator.LoadSettings(FCallXSettings);
end;

procedure TfrmChangeVideoMatrix.FormDestroy(Sender: TObject);
begin
  CallX.shutdown; // have to do it! or shutdown2()
end;

procedure TfrmChangeVideoMatrix.miConnectionSettingClick(Sender: TObject);
begin
  if FStarted then
    ShowConfigurator(CallX);
end;

procedure TfrmChangeVideoMatrix.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChangeVideoMatrix.miHardwareSettingClick(Sender: TObject);
begin
  if TfrmHardware.ShowDialog(self, TfrmConfigurator.GetRegKey, CallX) then
  begin

  end;
end;

procedure TfrmChangeVideoMatrix.WriteLog(ALine: string);
begin
  if not FCallXSettings.bWriteLog then
    Exit;

  { write to log file }
  Log(NowToString + ' ' + ALine);
end;

// { "matrixType": 1,
//   "participants": [ "brasilia@conference.oversee.com.br", "amynthas@conference.oversee.com.br" ] }
procedure TfrmChangeVideoMatrix.actShakeUpExecute(Sender: TObject);

  procedure _ShakeUpStrings(AStrings: TStrings);
  var ii, iRandomIdx: integer;
    s: string;
  begin
    Randomize;
    if lbParticipants.Items.Count < 2 then
    begin

    end
    else if lbParticipants.Items.Count < 4 then
    begin
      s := lbParticipants.Items[0];
      lbParticipants.Items.Delete(0);
      lbParticipants.Items.Add(s)
    end
    else for ii := 0 to AStrings.Count - 1 do
    begin
      iRandomIdx := Random(AStrings.Count - 1);
      if iRandomIdx <> ii then
      begin
        s := lbParticipants.Items[0];
        lbParticipants.Items.Delete(0);
        lbParticipants.Items.Insert(iRandomIdx, s);
      end;
    end;
  end;

var sParticipants, sJSONResult, sUser: string;
  i: integer;
begin
  sParticipants := '';

  { Shake up }
  _ShakeUpStrings(lbParticipants.Items);

  for i := 0 to lbParticipants.Items.Count - 1 do
  begin
    if i <> 0 then
      sParticipants := sParticipants + ', ';

    sParticipants := sParticipants + '"' + lbParticipants.Items[i] + '"';
  end;

  // Prepare a JSON string
  sJSONResult := Format('{"matrixType": %d, "participants": [%s]}', [rgMatrixType.ItemIndex, sParticipants]);
  // Ñhange video layout
  CallX.changeVideoMatrix(sJSONResult);
end;

procedure TfrmChangeVideoMatrix.actShakeUpUpdate(Sender: TObject);
begin
  actShakeUp.Enabled := (FStatus in [csInConference])
    and (lbParticipants.Items.Count > 0);
end;

procedure TfrmChangeVideoMatrix.CallXChangeVideoMatrixReport(ASender: TObject;
  const eventDetails: WideString);
begin
  memoLog.Lines.Insert(0, '=== OnChangeVideoMatrixReport =====================');
  memoLog.Lines.Insert(0, eventDetails);
end;

procedure TfrmChangeVideoMatrix.CallXInviteReceived(ASender: TObject;
  const eventDetails: WideString);
begin
  CallX.accept;
end;

procedure TfrmChangeVideoMatrix.CallXServerConnected(ASender: TObject;
  const eventDetails: WideString);
begin
  WriteLog('OnServerConnected: ' + eventDetails);
  if (FCallXSettings.sUser <> '') and (FCallXSettings.sPassword <> '') then
  begin
    WriteLog('Try to login: ' + FCallXSettings.sUser);
    CallX.login(FCallXSettings.sUser, FCallXSettings.sPassword)
  end
  else
    WriteLog('Empty login info');
end;

procedure TfrmChangeVideoMatrix.CallXUpdateParticipantList(ASender: TObject;
  const eventDetails: WideString);
begin
  memoLog.Lines.Insert(0, '=== OnUpdateParticipantList =======================');
  memoLog.Lines.Insert(0, eventDetails);
  memoLog.Lines.Insert(0, '=== getParticipantsList() =======================');
  memoLog.Lines.Insert(0, CallX.getParticipantsList());
  lbParticipants.Items.Text := JSON_ParticipantsListToText(CallX.getParticipantsList());
end;

end.
