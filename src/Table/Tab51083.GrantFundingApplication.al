table 51083 "Grant Funding Application"
{
    LookupPageId = "Proposals List";
    DrillDownPageId = "Proposals List";

    fields
    {
        field(1; "Application No"; Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Application No" <> xRec."Application No" THEN BEGIN
                    GrantsSetup.GET;
                    NoSeriesMgt.TestManual(GrantsSetup."Proposal Nos");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "FOA ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Funding Opportunity";

            trigger OnValidate();
            begin
                IF FOA.GET("FOA ID") THEN BEGIN
                    "External Document No" := FOA."External Announcement No";
                    "Opportunity  Title" := FOA.Title;
                    "Call Type" := FOA."Call Type";
                    "Grant Class" := FOA."Grant Class";
                    "Grant Type" := FOA."Grant Type";
                END;
            end;
        }
        field(4; "External Document No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Opportunity  Title"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Call Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Call For Proposals,Call For Application,Call for Concept Notes,Call For Nominations,Expression of Interest';
            OptionMembers = "Call For Proposals","Call For Application","Call for Concept Notes","Call For Nominations","Expression of Interest";
        }
        field(8; "Grant Type"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Types New";
        }
        field(9; "Justification for Application"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Research Center"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(11; "Primary Research Program ID"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Primary Research Area"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Principal Investigator"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate();
            begin
                IF NOT (CurrFieldNo IN [0, FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                    TESTFIELD("Approval Status", "Approval Status"::Open);
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
        field(16; "Requested Grant Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Requested Grant Amount(LCY)" := "Requested Grant Amount"
                ELSE
                    "Requested Grant Amount(LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                         "Requested Grant Amount", "Currency Factor"));
            end;
        }
        field(17; "Requested Grant Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Awarded Grant Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Awarded Grant Amount (LCY)" := "Awarded Grant Amount"
                ELSE
                    "Awarded Grant Amount (LCY)" := ROUND(
                       CurrExchRate.ExchangeAmtFCYToLCY(
                         "Posting Date", "Currency Code",
                         "Awarded Grant Amount", "Currency Factor"));
            end;
        }
        field(19; "Awarded Grant Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Application Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Not Started,InProgress,Won,Lost';
            OptionMembers = "Not Started",InProgress,Won,Lost;
        }
        field(21; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(22; "Grant Admin Team Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Closed Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Grantor No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF Customer.GET("Grantor No.") THEN BEGIN
                    "Grantor Name" := Customer.Name;
                END;
            end;
        }
        field(27; "Grantor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; Address; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; Address2; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Post Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Phone No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Mobile Phone No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Grantor Research Contact ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnValidate();
            begin
                IF Contact.GET("Grantor Research Contact ID") THEN BEGIN
                    "Grantor Research Reviewer" := Contact.Name;
                END;
            end;
        }
        field(36; "Grantor Research Reviewer"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Grantor Admin Contact ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnValidate();
            begin
                IF Contact.GET("Grantor Admin Contact ID") THEN BEGIN
                    "Grantor Admin Name" := Contact.Name;
                END;
            end;
        }
        field(38; "Grantor Admin Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Grantor Finance Contact ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnValidate();
            begin
                IF Contact.GET("Grantor Finance Contact ID") THEN BEGIN
                    "Grantor Finance Contact" := Contact.Name;
                END;
            end;
        }
        field(40; "Grantor Finance Contact"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Application Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Application Submitted Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Estimated Award Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(45; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Grant Class"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(47; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Date Closed"; Date)
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
        field(99; Concept; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Concept Notes"."No." WHERE("Approval Status" = FILTER(Approved));

            trigger OnValidate();
            var
                ConceptRec: Record "Concept Notes";
            begin
                ConceptRec.RESET;
                ConceptRec.GET(Concept);
                Description := ConceptRec.Description;
                ConceptRec.Status := ConceptRec.Status::Proposal;
                ConceptRec.MODIFY;
            end;
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Application No" = '' THEN BEGIN
            GrantsSetup.GET;
            GrantsSetup.TESTFIELD("Proposal Nos");
            NoSeriesMgt.InitSeries(GrantsSetup."Proposal Nos", xRec."No. Series", 0D, "Application No", "No. Series");
        END;

        "Created By" := USERID;
        "Created On" := TODAY;
        "Document Date" := TODAY;
    end;

    var
        GrantsSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FOA: Record "Funding Opportunity";
        CurrencyDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        MissingExchangeRatesQst: Label 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', Comment = '%1 - currency code, %2 - posting date';
        Confirmed: Boolean;
        Text021: Label 'Do you want to update the exchange rate?';
        HideValidationDialog: Boolean;
        Customer: Record Customer;
        Contact: Record Contact;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyCode: Code[10];
        GLSetupRead: Boolean;

    local procedure UpdateCurrencyFactor();
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        Updated: Boolean;
    begin


        IF "Currency Code" <> '' THEN BEGIN
            IF "Posting Date" <> 0D THEN
                CurrencyDate := "Posting Date"
            ELSE
                CurrencyDate := WORKDATE;

            IF UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") THEN BEGIN
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
                IF "Currency Code" <> xRec."Currency Code" THEN
                    RecreateSalesLines(FIELDCAPTION("Currency Code"));
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
        IF Confirm(Text021, false) = true THEN
            VALIDATE("Currency Factor")
        ELSE
            "Currency Factor" := xRec."Currency Factor";
    end;



    local procedure RecreateSalesLines(ChangedFieldName: Text[100]);
    var

    begin


    end;

    local procedure RevertCurrencyCodeAndPostingDate();
    begin
        "Currency Code" := xRec."Currency Code";
        "Posting Date" := xRec."Posting Date";
    end;





    local procedure FnReCalculateAmountLCY(ChangedFieldName: Text[100]);
    begin
        IF (ChangedFieldName = '') THEN BEGIN
            "Requested Grant Amount(LCY)" := "Requested Grant Amount";
        END;
        IF (ChangedFieldName <> '') THEN BEGIN
            "Requested Grant Amount(LCY)" := "Requested Grant Amount" * "Currency Factor";
        END;
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
