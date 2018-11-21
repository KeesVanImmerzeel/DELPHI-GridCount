unit uGridCount;

interface

uses
  Windows, Forms, SysUtils, StdCtrls, Controls, Classes,{ uProgramSettings,} FileCtrl,
  uTSingleESRIgrid, AVGRIDIO, Dialogs, uTabstractESRIgrid, uError,
  System.UITypes;

type
  TMainForm = class(TForm)
    LabelESRIGRIDrasterdataset: TLabel;
    EditGrof: TEdit;
    Label1: TLabel;
    EditFijn: TEdit;
    SingleESRIgridGrof: TSingleESRIgrid;
    SingleESRIgridFijn: TSingleESRIgrid;
    Go: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure EditGrofClick(Sender: TObject);
    procedure EditFijnClick(Sender: TObject);
   
    procedure GoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$R *.DFM}


procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  InitialiseGridIO;
  Caption :=  ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FinaliseLogFile;
end;

procedure TMainForm.EditGrofClick(Sender: TObject);
var
  Directory: string;
begin
  if SysUtils.DirectoryExists( EditGrof.Text ) then
    Directory := EditGrof.Text
  else Directory := GetCurrentDir;
  if SelectDirectory( Directory,  [], 0 ) then begin
    EditGrof.Text := ExpandFileName( Directory );
  end;
end;

procedure TMainForm.EditFijnClick(Sender: TObject);
var
  Directory: string;
begin
  if SysUtils.DirectoryExists( EditFijn.Text ) then
    Directory := EditFijn.Text
  else Directory := GetCurrentDir;
  if SelectDirectory( Directory,  [], 0 ) then begin
    EditFijn.Text := ExpandFileName( Directory );
  end;
end;


procedure TMainForm.GoClick(Sender: TObject);
var
  iResult, i, j, k, l, CellDepth: Integer;
  x, y, aCountValue: Single;

begin
  with OpenDialog1 do begin
    if execute then begin

  SingleESRIgridGrof := TSingleESRIgrid.InitialiseFromESRIGridFile( EditGrof.Text, iResult, self );
  SingleESRIgridFijn := TSingleESRIgrid.InitialiseFromESRIGridFile( EditFijn.Text, iResult, self );

  {-Zet de teller (vh aantal kleine cellen i.d. grove cellen) op nul in het grove grid}
  with SingleESRIgridGrof do begin
    for i:= 1 to NRows do begin
      for j:=1 to NCols do begin
        if ( GetValue( i, j ) <> MissingSingle ) then
          SetValue( i, j, 0 );
      end;
    end;
  end;

  with SingleESRIgridFijn do begin
    for i:= 1 to NRows do begin
      for j:=1 to NCols do begin
        if ( GetValue( i, j ) <> MissingSingle ) then begin
          {Writeln( lf, i, ' ', j, ' ', GetValue( i, j ) );}
          GetCellCentre( i, j, x, y );
          SingleESRIgridGrof.GetValueNearXY( x, y, 0, CellDepth, aCountValue );
          if ( aCountValue <> MissingSingle ) then begin
            aCountValue := aCountValue + 1;
            SingleESRIgridGrof.XYToWindowColRow( x, y, k,l );
            SingleESRIgridGrof.SetValue( k, l, aCountValue );
            // Writeln( lf, k, ' ', l, ' ', aCountValue:10:0 );
          end;
        end;
      end;
    end;
  end;
  {SingleESRIgridGrof.SaveAs( Filename, lf );}
  SingleESRIgridGrof.ExportToASC( Filename );
  MessageDlg( 'Finished.', mtInformation, [mbOk], 0 );

  end;
  end;
end;

end.
