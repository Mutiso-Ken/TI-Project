codeunit 50090 Notifications
{
    trigger OnRun()
    begin

    end;


    procedure fnSendemail(recipientName: Text;
    subject: Text;
    body: text;
    recipientEmail: Text;
    addCC: Text;
    addBcc: text;
    hasAttachment: Boolean;
    attachmentName: Text;
    attachmentType: Text;
    attachmentBase64: Text;
    Scenario: Enum "Email Scenario"
) res: Text
    var
        Companyinforec: Record "Company Information";
        CuEmail: Codeunit Email;
        CuEmailMessage: Codeunit "Email Message";
        EmailReceipientType: Enum "Email Recipient Type";
        Response: JsonObject;
        InputTkn: JsonToken;
        EmailAccount: Record "Email Account";
        templobCu: Codeunit "Temp Blob";
    begin
        Companyinforec.GET;

        CuEmailMessage.Create('', Subject, '');
        CuEmailMessage.SetBodyHTMLFormatted(true);
        CuEmailMessage.SetRecipients(EmailReceipientType::"To", RecipientEmail);
        if AddCC <> '' then
            CuEmailMessage.SetRecipients(EmailReceipientType::CC, AddCC);
        if AddBcc <> '' then
            CuEmailMessage.SetRecipients(EmailReceipientType::BCC, AddBcc);
        if hasAttachment then begin
            CuEmailMessage.AddAttachment(AttachmentName, AttachmentType, AttachmentBase64);
        end;
        CuEmailMessage.AppendToBody('<html> <body> <font face="Calibri,Arial,Tahoma", size = "3">');
        CuEmailMessage.AppendToBody('Dear ' + "RecipientName" + ',');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody(Body);
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('The attached document is in secure format. Kindly note the password is your five digit Member Number_Account Phone Number. E.g 00000_0700000000.');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('Incase You have forgotten your member number or your account phone number, please contact the nearest branch.');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('If you are unable to open the attachment, install a PDF reader of your own choice or download Adobe PDF Reader using link below');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('<a href="https://get.adobe.com/reader/">Download Adobe Reader</a>');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('<b>Note:</b>');
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('<ul>');
        CuEmailMessage.AppendToBody('<li>Please ensure you have a secure internet connection to access the attachment.</li>');
        CuEmailMessage.AppendToBody('<li>If you have any questions or need further assistance, do not hesitate to contact our customer service team</li>');
        CuEmailMessage.AppendToBody('</ul>');
        CuEmailMessage.AppendToBody('<HR>');
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('<b>This email is CONFIDENTIAL and is automatically generated, please do not reply to this address.</b>');
        CuEmailMessage.AppendToBody('<br><br>');
        CuEmailMessage.AppendToBody('Kind Regards');
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody(Companyinforec.Name);
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody(Companyinforec.Address);
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('Tel: ' + Companyinforec."Phone No.");
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody(Companyinforec."E-Mail");
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody(Companyinforec."Home Page");
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('<br>');
        CuEmailMessage.AppendToBody('<b>Note</b> This e-mail and any attachments are confidential. ' +
        'They may contain privileged information and are intended for the named addressee(s) only. ' +
        'Unless expressly stated, opinions in this e-mail are those of the individual sender and not of Transparency International Kenya. ' +
        'Any review, retransmission, dissemination, or other use of, or taking of any action in reliance upon this ' +
        'information by persons or entities other than the intended recipient is prohibited. ' +
        'If you are not the intended recipient, please notify the sender and delete this message and ' +
        'any attachments immediately.');

        if CuEmail.Send(CuEmailMessage, Scenario) then begin
            Response.Add('sent', true);
            Response.Add('status', '200');
            Response.Add('message', 'Email Sent Successfully');
        end else begin
            Response.Add('sent', false);
            Response.Add('status', '400');
            Response.Add('message', 'Email Not Sent');
            Response.Add('error', GetLastErrorText());
        end;
        Response.WriteTo(res);
        exit(res);
    end;






    var
        myInt: Integer;
}