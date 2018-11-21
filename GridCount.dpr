program GridCount;

uses
  Forms,
  Sysutils,
  Dialogs,
  uError,
  System.UITypes,
  uGridCount in 'uGridCount.pas' {MainForm}{,
  uProgramSettings in '..\Default\uProgramSettings.pas'};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Try
    Try
      if ( Mode = Interactive ) then begin
        Application.Run;
      end else begin
        {MainForm.GoButton.Click;}
      end;
    Except
      Try WriteToLogFile( Format( 'Error in application: [%s].', [Application.ExeName] ) ); except end;
      MessageDlg( Format( 'Error in application: [%s].', [Application.ExeName] ), mtError, [mbOk], 0);
    end;
  Finally
  end;

end.
