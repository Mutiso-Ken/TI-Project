table 51089 RFA
{

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Title; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Currency; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate();
            begin
                IF Currency <> '' THEN
                    "Currency Factor" := ObjExchRate.ExchangeRate(TODAY, Currency);
            end;
        }
        field(4; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Request for Application,Limited solicitation,Non-Competitive';
            OptionMembers = "Request for Application","Limited solicitation","Non-Competitive";
        }
        field(6; "Awarded Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Currency Factor" <> 0 THEN BEGIN
                    "Awarded Amount(LCY)" := "Awarded Amount" / "Currency Factor";
                END ELSE
                    "Awarded Amount(LCY)" := "Awarded Amount";
            end;
        }
        field(7; "Awarded Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Stage; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Bidding,Preliminary Assessment,Evaluation,Peer Review,Technical Review,Pre Award Survey,Sub Award';
            OptionMembers = New,Bidding,"Preliminary Assessment",Evaluation,"Peer Review","Technical Review","Pre Award Survey","Sub Award";
        }
        field(11; "Approved Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Currency Factor" <> 0 THEN BEGIN
                    "Approved Amount (LCY)" := "Approved Amount" / "Currency Factor";
                END ELSE
                    "Awarded Amount(LCY)" := "Approved Amount";
            end;
        }
        field(12; "Approved Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Donor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                ObjCust.RESET;
                ObjCust.SETRANGE("No.", Donor);
                IF ObjCust.FIND('-') THEN BEGIN
                    "Name of Donor" := ObjCust.Name;
                    "Email of Donor" := ObjCust."E-Mail";
                    "Address of Donor" := ObjCust.Address;
                    "Phone Number" := ObjCust."Phone No.";
                END;
            end;
        }
        field(14; "Name of Donor"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Email of Donor"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Address of Donor"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Publish to Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Organization Background"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "RFA Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "RFA File Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Awarded Partner"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE("Account Type" = FILTER("Implementing Partner"));
        }
        field(25; "Closing On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(26; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF No = '' THEN BEGIN
            SubAwards.RESET;
            IF SubAwards.FINDLAST THEN BEGIN
                No := INCSTR(SubAwards.No);
            END ELSE BEGIN
                No := 'AWARD0001';
            END;
        END;
        "Created On" := CREATEDATETIME(TODAY, TIME);
        "Created By" := USERID;
    end;

    var
        SubAwards: Record "RFA";
        ObjCust: Record "Customer";
        ObjExchRate: Record "Currency Exchange Rate";
}
