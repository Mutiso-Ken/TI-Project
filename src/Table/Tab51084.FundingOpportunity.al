table 51084 "Funding Opportunity"
{


    fields
    {
        field(1; "Call No."; Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Call No." <> xRec."Call No." THEN BEGIN
                    GrantsSetup.GET;
                    NoSeriesMgt.TestManual(GrantsSetup."Grantor Nos");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Organization ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnValidate();
            begin
                Contacts.RESET;
                Contacts.SETRANGE("No.", "Organization ID");
                IF Contacts.FIND('-') THEN BEGIN
                    "Issuing Organization" := Contacts.Name;
                END;
            end;
        }
        field(3; "Issuing Organization"; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Call Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Call For Proposals,Call For Application,Call for Concept Notes,Call For Nominations,Expression of Interest,Sole Source';
            OptionMembers = "Call For Proposals","Call For Application","Call for Concept Notes","Call For Nominations","Expression of Interest","Sole Source";
        }
        field(5; "External Announcement No"; Code[150])
        {
            DataClassification = ToBeClassified;
            Description = 'e.g. website';
        }
        field(6; "Release Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'when the call was published';
        }
        field(7; "Opening Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Earliest submission date';
            Enabled = false;
        }
        field(8; "Application Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Application date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'changed from Earliest Start Date to  Application date';
        }
        field(10; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Home Page"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(14; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Opportunity Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Opportunity Amount(LCY)" := "Opportunity Amount"
                ELSE
                    "Opportunity Amount(LCY)" := ROUND(
                       CurrExchRate.ExchangeAmtFCYToLCY(
                         "Posting Date", "Currency Code",
                         "Opportunity Amount", "Currency Factor"));
            end;
        }
        field(17; "Opportunity Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Currency Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate();
            begin
                IF NOT (CurrFieldNo IN [0, FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                    TESTFIELD(Status, Status::Open);
                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                    UpdateCurrencyFactor
                ELSE
                    IF "Currency Code" <> xRec."Currency Code" THEN
                        UpdateCurrencyFactor
                    ELSE
                        IF "Currency Code" <> '' THEN BEGIN
                            UpdateCurrencyFactor;
                            IF "Currency Factor" <> xRec."Currency Factor" THEN
                                ConfirmUpdateCurrencyFactor;
                        END;
            end;
        }
        field(19; "Title Details"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Title; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Grantor No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(22; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                VALIDATE("Currency Code");
            end;
        }
        field(23; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
            end;
        }
        field(24; "Opportunity Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Submitted,Received';
            OptionMembers = Open,Submitted,Received;
        }
        field(25; "Donor Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(26; "Grant Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Types New".Code;

            trigger OnValidate();
            begin
                IF GrantTypes.GET("Grant Type") THEN BEGIN
                    IF (GrantTypes.Type = GrantTypes.Type::External) THEN BEGIN
                        "Grant Class" := "Grant Class"::External;
                    END;

                    IF (GrantTypes.Type = GrantTypes.Type::Internal) THEN BEGIN
                        "Grant Class" := "Grant Class"::Internal;
                    END;
                END;
            end;
        }
        field(27; "Grant Class"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(28; "Project Duration"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(95; "Additional-Currency Posting"; Option)
        {
            Caption = 'Additional-Currency Posting';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'None,Amount Only,Additional-Currency Amount Only';
            OptionMembers = "None","Amount Only","Additional-Currency Amount Only";
        }
        field(98; "FA Add.-Currency Factor"; Decimal)
        {
            Caption = 'FA Add.-Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Call No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Call No." = '' THEN BEGIN
            GrantsSetup.GET;
            GrantsSetup.TESTFIELD("Grantor Nos");
            NoSeriesMgt.InitSeries(GrantsSetup."Grantor Nos", xRec."No. Series", 0D, "Call No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "Created By" := USERID;
    end;

    var
        GrantsSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Contacts: Record Contact;
        CurrencyDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        Confirmed: Boolean;
        HideValidationDialog: Boolean;
        MissingExchangeRatesQst: Label 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', Comment = '%1 - currency code, %2 - posting date';
        Text021: Label 'Do you want to update the exchange rate?';
        GrantTypes: Record "Grant Types New";
        GLSetup: Record "General Ledger Setup";
        CurrencyCode: Code[10];
        Currency: Record Currency;
        GLSetupRead: Boolean;



    local procedure UpdateCurrencyFactor();
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        Updated: Boolean;
    begin
        IF Updated THEN
            EXIT;

        IF "Currency Code" <> '' THEN BEGIN
            IF "Posting Date" <> 0D THEN
                CurrencyDate := "Posting Date"
            ELSE
                CurrencyDate := WORKDATE;

            IF UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") THEN BEGIN
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            END ELSE BEGIN
                IF CONFIRM(STRSUBSTNO(MissingExchangeRatesQst, "Currency Code", CurrencyDate)) THEN BEGIN
                    COMMIT;
                    UpdateCurrencyExchangeRates.OpenExchangeRatesPage("Currency Code");
                    UpdateCurrencyFactor;
                END ELSE
                    RevertCurrencyCodeAndPostingDate;
            END;
        END ELSE
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor();
    begin
        if Confirm(Text021, false) = true then
            VALIDATE("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    local procedure RevertCurrencyCodeAndPostingDate();
    begin
        "Currency Code" := xRec."Currency Code";
        "Posting Date" := xRec."Posting Date";
    end;


    local procedure GetCurrency();
    begin
        IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
            IF GLSetup."Additional Reporting Currency" = '' THEN
                ReadGLSetup;
            CurrencyCode := GLSetup."Additional Reporting Currency";
        END ELSE
            CurrencyCode := "Currency Code";

        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE
            IF CurrencyCode <> Currency.Code THEN BEGIN
                Currency.GET(CurrencyCode);
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
    end;

    local procedure ReadGLSetup();
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
    end;
}
