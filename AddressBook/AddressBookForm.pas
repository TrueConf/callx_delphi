unit AddressBookForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, TrueConf_CallXLib_TLB,
  Vcl.Menus, ConfigForm, UserCacheUnit, Vcl.ExtCtrls, Vcl.StdCtrls, CallX_Common,
  HardwareForm, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList,
  Vcl.ComCtrls;

const
  TITLE = 'Address Book Demo';

type
  TfrmAddressBook = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    miExit: TMenuItem;
    miTools: TMenuItem;
    miConnectionSetting: TMenuItem;
    miHardwareSetting: TMenuItem;
    Splitter: TSplitter;
    pmAddressBook: TPopupMenu;
    ActionList: TActionList;
    actCall: TAction;
    Call1: TMenuItem;
    ImageList: TImageList;
    pnlLeft: TPanel;
    pnlButtons: TPanel;
    Button1: TButton;
    Button2: TButton;
    actHangUp: TAction;
    grbAB: TGroupBox;
    lvAddressBook: TListView;
    grbCallX: TGroupBox;
    CallX: TTrueConfCallX;
    procedure miExitClick(Sender: TObject);
    procedure miConnectionSettingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CallXAbookUpdate(ASender: TObject;
      const eventDetails: WideString);
    procedure CallXXAfterStart(Sender: TObject);
    procedure CallXXChangeState(ASender: TObject; prevState, newState: Integer);
    procedure CallXServerConnected(ASender: TObject;
      const eventDetails: WideString);
    procedure actCallUpdate(Sender: TObject);
    procedure actCallExecute(Sender: TObject);
    procedure CallXInviteReceived(ASender: TObject;
      const eventDetails: WideString);
    procedure lvAddressBookDblClick(Sender: TObject);
    procedure actHangUpExecute(Sender: TObject);
    procedure actHangUpUpdate(Sender: TObject);
    procedure CallXXError(ASender: TObject; errorCode: Integer;
      const errorMsg: WideString);
    procedure CallXXLoginError(ASender: TObject; errorCode: Integer);
    procedure CallXDetailInfo(ASender: TObject; const eventDetails: WideString);
    procedure miHardwareSettingClick(Sender: TObject);
    procedure CallXLogout(ASender: TObject; const eventDetails: WideString);
  private
    // server, call_id, password and others...
    FCallXSettings: TCallXSettings;
    // TrueConf CallX has already started working
    FStarted: boolean;
    // Address book
    FAddressBook: TAddressBook;
    // current authorized user status
    FStatus: TMyStatus;
    // current user's detail info
    FMyDetailInfo: string;
  protected
    procedure WriteLog(ALine: string);
    procedure UpdateAddressBook;
  public
    { Public declarations }
  end;

var
  frmAddressBook: TfrmAddressBook;

implementation

{$R *.dfm}

uses LogUnit;

// -1      - unknown user
//  0       - offline
//  1       - online (avialable)
//  2       - busy
//  5       - conference owner
// TTUserStatus = (usUnknown, usOffline, usAvialable, usBusy, usConferenceOwner);

//function UserToRowText(AUserID, ADisplayName: string; AUserStatus: integer): string;
//var status: TUserStatus;
//begin
//  Result := ADisplayName;
//  status := IntToUserStatus(AUserStatus);
//  case status of
//    usUnknown:         Result := Format('[unknown]%s', [ADisplayName]);
//    usOffline:         Result := Format('[offline]%s', [ADisplayName]);
//    usAvialable:       Result := Format('[avialable]%s', [ADisplayName]);
//    usBusy:            Result := Format('[busy]%s', [ADisplayName]);
//    usConferenceOwner: Result := Format('[conference owner]%s', [ADisplayName]);
//  end;
//end;

{ Get a image index that match to user status }
function StatusToImageIndex(AStatus: integer): integer;
begin
  Result := 0;

  case IntToUserStatus(AStatus) of
    usOffline: Result := 1;
    usAvialable: Result := 2;
    usBusy: Result := 3;
    usConferenceOwner: Result := 4;
  end;
end;

{ Call user }
procedure TfrmAddressBook.actCallExecute(Sender: TObject);
var sCallID: string;
begin
  if lvAddressBook.ItemIndex < 0 then
    Exit;

  sCallID := lvAddressBook.Items[lvAddressBook.ItemIndex].SubItems[0];
  CallX.call(sCallID);
end;

{ I can call when my status is csNormal only }
procedure TfrmAddressBook.actCallUpdate(Sender: TObject);
begin
  actCall.Enabled := (FStatus = csNormal) and (lvAddressBook.ItemIndex > -1);
end;

{ Hang up }
procedure TfrmAddressBook.actHangUpExecute(Sender: TObject);
begin
  CallX.hangUp;
end;

{ I can hang up when my status is csWait or csInConference }
procedure TfrmAddressBook.actHangUpUpdate(Sender: TObject);
begin
  actHangUp.Enabled := FStatus in [csWait, csInConference];
end;

{ Address book update event handler }
procedure TfrmAddressBook.CallXAbookUpdate(ASender: TObject;
  const eventDetails: WideString);
var s: string;
begin
  s := eventDetails;
  FAddressBook.Update(s);
  UpdateAddressBook;
end;

{ Event handler - getting my detail info }
procedure TfrmAddressBook.CallXDetailInfo(ASender: TObject;
  const eventDetails: WideString);
begin
  FMyDetailInfo := eventDetails;
  MessageDlg('DetailInfo:'#13#10 + eventDetails, mtInformation, [mbOK], 0);
end;

{ Event handler - Invite }
{ You can call "accept()" or "reject()" }
procedure TfrmAddressBook.CallXInviteReceived(ASender: TObject;
  const eventDetails: WideString);
begin
  // always accept any calls
  CallX.accept;
end;

{ Event handler - when I logged out }
procedure TfrmAddressBook.CallXLogout(ASender: TObject;
  const eventDetails: WideString);
begin
  FMyDetailInfo := '';
end;

{ succesfully connected to the server (See: TCallXSettings.sServer param) }
{ Ussualy in this event handler we calls login() function }
procedure TfrmAddressBook.CallXServerConnected(ASender: TObject;
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

{ OnXAfterStart event handler }
{ When CallX component is succesfully started }
{ I recommend set the hardware ((camera, microphone, speakers))
  in this event handler }
procedure TfrmAddressBook.CallXXAfterStart(Sender: TObject);
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

{ One of the Important handler }
{ Handle this event to know your current status }
procedure TfrmAddressBook.CallXXChangeState(ASender: TObject; prevState,
  newState: Integer);
begin
  FStatus := IntToMyStatus(newState);
  Caption := Format('%s. Authorized user: %s [%s]', [TITLE, FCallXSettings.sUser, IntToMyStringState(newState)]);
  if (FStatus = csNormal) and (FMyDetailInfo = '') then
    CallX.getContactDetails(FCallXSettings.sUser);
end;

{ Any errors }
procedure TfrmAddressBook.CallXXError(ASender: TObject; errorCode: Integer;
  const errorMsg: WideString);
begin
  MessageDlg(errorMsg, mtError, [mbOK], 0);
end;

{ Login Error handling }
{
 0 - Login successful, otherwise error code
 1 - Answer on CheckUserLoginStatus_Method, if current CID is already authorized at TransportRouter
 2 - Answer on CheckUserLoginStatus_Method, if current CID is not authorized at TransportRouter - can try to login
 3 - Incorrect password or other problems with DB
 4 - Client shouldn't show error to user (example: incorrect AutoLoginKey)
 5 - License restriction of online users reached, server cannot login you
 6 - User exist, but he is disabled to use this server
 7 - Client should retry login after timeout (value in container or default), due to server busy or other server problems
 8 - User cannot login using this client app (should use other type of client app)
}
procedure TfrmAddressBook.CallXXLoginError(ASender: TObject;
  errorCode: Integer);
begin
  MessageDlg(GetLoginErrorMsg(errorCode), mtError, [mbOK], 0);
end;

procedure TfrmAddressBook.FormCreate(Sender: TObject);
begin
  FStatus := csBeforeInit;
  Caption := TITLE + ' [connecting...]';

  { Get settings: server, call_id, password }
  TfrmConfigurator.LoadSettings(FCallXSettings);
  FAddressBook := TAddressBook.Create;
  lvAddressBook.Clear;
  with lvAddressBook.Items.Add do
  begin
    Caption := 'Loading...';
    ImageIndex := -1;
  end;
end;

procedure TfrmAddressBook.FormDestroy(Sender: TObject);
begin
  CallX.shutdown; // have to do it! or shutdown2()
  FreeAndNil(FAddressBook);
end;

procedure TfrmAddressBook.lvAddressBookDblClick(Sender: TObject);
begin
  if actCall.Enabled then
    actCall.Execute;
end;

procedure TfrmAddressBook.miConnectionSettingClick(Sender: TObject);
begin
  if FStarted then
    ShowConfigurator(CallX);
end;

procedure TfrmAddressBook.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddressBook.miHardwareSettingClick(Sender: TObject);
begin
  if TfrmHardware.ShowDialog(self, TfrmConfigurator.GetRegKey, CallX) then
  begin

  end;
end;

{ Update the Address Book List }
procedure TfrmAddressBook.UpdateAddressBook;
var i, idx: integer;
  sSelectedUser: string;
  item: TListItem;
begin
  if lvAddressBook.ItemIndex > -1 then
    sSelectedUser := lvAddressBook.Items[lvAddressBook.ItemIndex].Caption;

  lvAddressBook.Items.BeginUpdate;
  try
    lvAddressBook.Items.Clear;
    for i := 0 to FAddressBook.Count - 1 do begin
      with lvAddressBook.Items.Add do begin
        Caption := FAddressBook[i].DisplayName;
        ImageIndex := StatusToImageIndex(FAddressBook[i].Status);
        SubItems.Add(FAddressBook[i].ID)
      end;
    end;
  finally
    lvAddressBook.Items.EndUpdate;
  end;

  item := lvAddressBook.FindCaption(0, sSelectedUser, False, False, False);
  if Assigned(item) then
    lvAddressBook.Selected := item;
end;

{ Write some text to the log file }
procedure TfrmAddressBook.WriteLog(ALine: string);
begin
  if not FCallXSettings.bWriteLog then
    Exit;

  { write to log file }
  Log(NowToString + ' ' + ALine);
end;

end.
