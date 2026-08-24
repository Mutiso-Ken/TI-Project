page 95012 "Quote Attached"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SharePoint Intergration";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { ApplicationArea = all; }//Editable = false; }
                field(Owner; Rec.Owner) { Caption = 'Vendor No.'; }
                field("Original File Name"; Rec."Original File Name") { ApplicationArea = all; Editable = false; }
                field(Base_URL; Rec.Base_URL) { ApplicationArea = all; ExtendedDatatype = URL; Editable = false; }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportDocument)
            {
                Caption = 'Attach';
                Promoted = true;
                ApplicationArea = All;
                Image = Attach;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    FileDialog: Dialog;//DotNet "'System.Windows.Forms' Microsoft.Win32.OpenFileDialog";
                    FileManagement: Codeunit "File Management";
                    FileName: Text[250];
                    FilePath: Text[250];
                    FolderPath: Text[250];
                    DestFilePath: Text[250];
                    InStream: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    PortalUploads: Record "SharePoint Intergration";
                    CompanyInformation: Record 79;
                    Type: Text;
                    UniqNumber: Decimal;
                    OutStream: OutStream;
                    CleanFileName: Text[250];
                    LocalUrl: Label 'https://self-service.rckkenya.org\\Downloads\';
                begin
                    UniqNumber := Random(100);
                    FolderPath := 'C:\inetpub\wwwroot\Staff Portal\Portal\Downloads\'; //CompanyInformation.Get();

                    if UploadIntoStream('Select a File to Import', '', '', FileName, InStream) then begin
                        TempBlob.CreateOutStream(OutStream);
                        CopyStream(OutStream, InStream);
                        DestFilePath := FolderPath + Format(UniqNumber) + FileName;

                        FileManagement.BLOBExportToServerFile(TempBlob, DestFilePath);

                        Message('File has been saved to folder Successfully');
                        CleanFileName := DELCHR(FileName, '=', '''');
                        PortalUploads.INIT;
                        PortalUploads."Document No" := Rec."Document No";
                        PortalUploads.Description := FileName;
                        PortalUploads.LocalUrl := LocalUrl + Format(UniqNumber) + FileName;
                        PortalUploads.Uploaded := TRUE;
                        PortalUploads.Fetch_To_Sharepoint := TRUE;
                        PortalUploads.Base_URL := 'ERP Documents' + '/' + Type + '/';
                        PortalUploads.INSERT(TRUE);
                    end else
                        Message('File import was canceled.');
                end;
            }
        }
    }


}