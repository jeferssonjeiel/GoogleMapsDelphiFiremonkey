unit app;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Layouts, FMX.Edit,
  FMX.WebBrowser, System.Sensors, System.Sensors.Components;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Layout1: TLayout;
    WebBrowser1: TWebBrowser;
    LocationSensor1: TLocationSensor;
    procedure Button1Click(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
     FGeocoder: TGeocoder;
     procedure OnGeocoderReverseEvent(const Address:TCivicAddress);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CodLocalidade: String;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
  var vURL : String;
  begin
    LocationSensor1.Active := Button1.Pressed;

    //vURL := 'https://maps.google.com/maps?q='+Edit1.Text+', '+Edit2.Text;
    //WebBrowser1.Navigate(vURL)
  end;

procedure TForm1.LocationSensor1LocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
  var URL: string;
      LDecSeparator: String;
      CodLocalidade: String;
  begin
    LDecSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';

    URL := Format(
    'https://maps.google.com/maps?q=%s,%s',
    [Format('%2.6f', [NewLocation.Latitude]), Format('%2.6f', [NewLocation.Longitude])]);
    WebBrowser1.Navigate(URL);

    try
        if(not Assigned(FGeocoder)) then
        begin
          if(Assigned(TGeocoder.Current)) then
             FGeocoder := TGeocoder.Current.Create;
          if(Assigned(FGeocoder)) then
             FGeocoder.OnGeocodeReverse := OnGeocoderReverseEvent;
        end;
        if(Assigned(FGeocoder) and not(FGeocoder.Geocoding)) then
           FGeocoder.GeocodeReverse(NewLocation);
    except
      ShowMessage('Error');
    end;

    CodLocalidade := 'NewLocation.Latitude + NewLocation.Longitude';
    WebBrowser1.Navigate(URL);

    ShowMessage(CodLocalidade);

  end;

procedure TForm1.OnGeocoderReverseEvent(const Address: TCivicAddress);
  begin
    Edit1.Text := Address.Locality;
    Edit2.Text := Address.SubLocality;
  end;

end.
