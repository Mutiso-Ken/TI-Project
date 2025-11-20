#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 170500 "TE Time Sheet1"
{
    // Serenic Navigator - (c)Copyright Serenic Software, Inc. 1999-2017.
    // By opening this object you acknowledge that this object includes confidential information
    // and intellectual property of Serenic Software, Inc., and that this work is protected by US
    // and international copyright laws and agreements.
    // ------------------------------------------------------------------------------------------

    Caption = 'Time Sheet Lines';

    fields
    {
        field(1; "Line No."; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = TimesheetLines.Timesheetcode;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = TimesheetLines.Timesheetcode;
        }
        field(5; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnValidate()
            begin
                UpdateDefaults;
            end;
        }
        field(10; "Week Start Date"; Date)
        {
            Caption = 'Week Start Date';
        }
        field(15; "Time Type Code"; Code[10])
        {
            Caption = 'Time Type Code';
        }
        field(20; Description; Text[1000])
        {
            Caption = 'Description';
        }
        field(30; "Day 1"; Decimal)
        {
            Caption = 'Day 1';

            trigger OnValidate()
            begin
                /*IF("Day 1" <> xRec."Day 1")THEN BEGIN
                TimeSheet.SETRANGE(TimeSheet."Day 1 Status",TimeSheet."Day 1 Status"::New);
                  IF TimeSheet.FIND('-') THEN
                    REPEAT
                      TimeControl := TimeControl + TimeSheet."Day 1";
                      UNTIL TimeSheet.NEXT=0;
                      IF((TimeControl+"Day 1") >8)THEN
                         ERROR(TX002);
                END;
                */

            end;
        }
        field(31; "Day 2"; Decimal)
        {
            Caption = 'Day 2';

            trigger OnValidate()
            begin
                if ("Day 2" <> xRec."Day 2") then begin
                    /*TimeSheet.SETRANGE(TimeSheet."Day 2 Status",TimeSheet."Day 2 Status"::New);
                      IF TimeSheet.FIND('-') THEN
                        REPEAT
                          TimeControl := TimeControl + TimeSheet."Day 2";
                          UNTIL TimeSheet.NEXT=0;
                          IF((TimeControl+"Day 2") >8)THEN
                       */
                    Error(TX002);
                end;

            end;
        }
        field(32; "Day 3"; Decimal)
        {
            Caption = 'Day 3';

            trigger OnValidate()
            begin
                if ("Day 3" <> xRec."Day 3") then begin
                    /*TimeSheet.SETRANGE(TimeSheet."Day 3 Status",TimeSheet."Day 3 Status"::New);
                      IF TimeSheet.FIND('-') THEN
                        REPEAT
                          TimeControl := TimeControl + TimeSheet."Day 3";
                          UNTIL TimeSheet.NEXT=0;
                          IF((TimeControl+"Day 3") >8)THEN
                            ERROR(TX002);
                            */
                end;

            end;
        }
        field(33; "Day 4"; Decimal)
        {
            Caption = 'Day 4';

            trigger OnValidate()
            begin
                if ("Day 4" <> xRec."Day 4") then begin
                    /*TimeSheet.SETRANGE(TimeSheet."Day 4 Status",TimeSheet."Day 4 Status"::New);
                      IF TimeSheet.FIND('-') THEN
                        REPEAT
                          TimeControl := TimeControl + TimeSheet."Day 4";
                          UNTIL TimeSheet.NEXT=0;
                          IF((TimeControl+"Day 4") >8)THEN
                             ERROR(TX002);*/
                end;

            end;
        }
        field(34; "Day 5"; Decimal)
        {
            Caption = 'Day 5';

            trigger OnValidate()
            begin
                if ("Day 5" <> xRec."Day 5") then begin
                    /*TimeSheet.SETRANGE(TimeSheet."Day 5 Status",TimeSheet."Day 5 Status"::New);
                      IF TimeSheet.FIND('-') THEN
                        REPEAT
                          TimeControl := TimeControl + TimeSheet."Day 5";
                          UNTIL TimeSheet.NEXT=0;
                          IF((TimeControl+"Day 5") >8)THEN
                             ERROR(TX002);*/
                end;

            end;
        }
        field(35; "Day 6"; Decimal)
        {
            Caption = 'Day 6';

            trigger OnValidate()
            begin
                /*IF("Day 6" <> xRec."Day 6")THEN BEGIN
                TimeSheet.SETRANGE(TimeSheet."Day 6 Status",TimeSheet."Day 6 Status"::New);
                  IF TimeSheet.FIND('-') THEN
                    REPEAT
                      TimeControl := TimeControl + TimeSheet."Day 6";
                      UNTIL TimeSheet.NEXT=0;
                      IF((TimeControl+"Day 6") >8)THEN
                         ERROR(TX002);
                  END;
                  */

            end;
        }
        field(36; "Day 7"; Decimal)
        {
            Caption = 'Day 7';

            trigger OnValidate()
            begin
                /*IF("Day 7" <> xRec."Day 7")THEN BEGIN
                TimeSheet.SETRANGE(TimeSheet."Day 7 Status",TimeSheet."Day 7 Status"::New);
                  IF TimeSheet.FIND('-') THEN
                    REPEAT
                      TimeControl := TimeControl + TimeSheet."Day 7";
                      UNTIL TimeSheet.NEXT=0;
                      IF((TimeControl+"Day 7") >8)THEN
                         ERROR(TX002);
                  END;
                  */

            end;
        }
        field(38; "Global Dimension 1 Code"; Code[200])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('FUND'));

            trigger OnValidate()
            begin


                DimValues.SetRange(DimValues.Code, "Global Dimension 1 Code");
                if DimValues.FindFirst then
                    Description := DimValues.Name;

                /*Usersetup.GET(USERID);
                Employee.SETRANGE("No.",Usersetup."Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                   "Employee No" := Employee."No.";
                  "Employee Name" := Employee."First Name" + '' + Employee."Last Name";
                  END;*/

            end;
        }
        field(39; "Global Dimension 2 Code"; Code[200])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(40; "Global Dimension 3 Code"; Code[200])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(41; "Global Dimension 4 Code"; Code[200])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(42; "Global Dimension 5 Code"; Code[200])
        {
            CaptionClass = '1,1,5';
            Caption = 'Global Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(43; "Global Dimension 6 Code"; Code[200])
        {
            CaptionClass = '1,1,6';
            Caption = 'Global Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(44; "Global Dimension 7 Code"; Code[200])
        {
            CaptionClass = '1,1,7';
            Caption = 'Global Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(45; "Global Dimension 8 Code"; Code[200])
        {
            CaptionClass = '1,1,8';
            Caption = 'Global Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(46; "Fund No."; Code[10])
        {
            Caption = 'Fund No.';

            trigger OnValidate()
            begin
                /*Fund.GET("Fund No.");
                IF Fund.Blocked = TRUE THEN
                  MESSAGE(TEText004, "Fund No.");*/

            end;
        }
        field(47; "Dimension Speedkey Code"; Code[10])
        {
            Caption = 'Dimension Speedkey Code';

            trigger OnValidate()
            begin
                /*IF DimensionSpeedkey.GET("Dimension Speedkey Code") THEN BEGIN
                  IF "Fund No." <> DimensionSpeedkey."Fund No." THEN
                    VALIDATE("Fund No.",DimensionSpeedkey."Fund No.");
                  VALIDATE("Global Dimension 1 Code", DimensionSpeedkey."Global Dimension 1 Code");
                  VALIDATE("Global Dimension 2 Code", DimensionSpeedkey."Global Dimension 2 Code");
                  VALIDATE("Global Dimension 3 Code", DimensionSpeedkey."Global Dimension 3 Code");
                  VALIDATE("Global Dimension 4 Code", DimensionSpeedkey."Global Dimension 4 Code");
                  VALIDATE("Global Dimension 5 Code", DimensionSpeedkey."Global Dimension 5 Code");
                  VALIDATE("Global Dimension 6 Code", DimensionSpeedkey."Global Dimension 6 Code");
                  VALIDATE("Global Dimension 7 Code", DimensionSpeedkey."Global Dimension 7 Code");
                  VALIDATE("Global Dimension 8 Code", DimensionSpeedkey."Global Dimension 8 Code");
                END;*/

            end;
        }
        field(70; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
        }
        field(150; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(300; "Internal Control No."; Code[50])
        {
            Caption = 'Internal Control No.';
        }
        field(305; DateDisplay; Date)
        {
            Caption = 'DateDisplay';
        }
        field(310; DayStatus; Option)
        {
            Caption = 'DayStatus';
            OptionCaption = 'New,Submitted,Approval Pending,Approved,Historical';
            OptionMembers = New,Submitted,"Approval Pending",Approved,Historical;
        }
        field(800; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(801; "Status Filter"; Option)
        {
            Caption = 'Status Filter';
            OptionCaption = 'New,Submitted,,Approved,Posted';
            OptionMembers = New,Submitted,,Approved,Posted;
        }
        field(50000; "Employee No"; Code[30])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if Employee.Get("Employee No") then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";

                /*IF("Employee No" <> xRec."Employee No")THEN BEGIN
                  IF Employee.GET("Employee No") THEN
                     "Employee Name"  := Employee."First Name"+' '+Employee."Last Name";
                  Employee.SETRANGE
                Supurvisor:=;
                END;
                
                */




                /*
                //approve for finance add
                Usersetup.RESET;
                Usersetup.SETRANGE("Employee No.","Employee No");
                IF Usersetup.FINDFIRST THEN BEGIN
                  IF "User ID"<>Usersetup."User ID" THEN
                    Status:=Status::Approved;
                  END;
                //end ;
                */
                /*
                Usersetup.RESET;
                Usersetup.SETRANGE("Employee No.","Employee No");
                IF Usersetup.FINDFIRST THEN BEGIN
                  "User ID":=Usersetup."User ID";
                END;
                */

            end;
        }
        field(50001; "Employee Name"; Text[100])
        {
        }
        field(50002; "Leave Type"; Code[30])
        {

            trigger OnValidate()
            begin

                Leave.Get("Leave Type");
                Description := Leave.Description;

                /*
                Usersetup.GET(USERID);
                Employee.SETRANGE("No.",Usersetup."Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                   "Employee No" := Employee."No.";
                  "Employee Name" := Employee."First Name" + '' + Employee."Last Name";
                  END;*/
                //END;

            end;
        }
        field(50003; Hours; Integer)
        {
        }
        field(50004; Date; Date)
        {

            trigger OnValidate()
            begin
                if Date > Today then
                    Error('You cannot book timesheet for a future date');


                Hrs := 0;
                TETimeSheet.Reset;
                TETimeSheet.SetRange(Date, Date);
                TETimeSheet.SetRange("Employee No", "Employee No");
                if TETimeSheet.FindSet then begin
                    repeat
                        Hrs := TETimeSheet.Hours;
                    until TETimeSheet.Next = 0;
                end;
                if Hrs + Hours > 14 then
                    Error('You cannot book for more than 14 hours in a day');


            end;
        }
        field(50005; Narration; Text[2048])
        {
        }
        field(50006; Supurvisor; Code[30])
        {
        }
        field(50007; "Program Accountant"; Code[30])
        {
        }
        field(50008; Sequency; Integer)
        {
        }
        field(50009; Status; Option)
        {
            OptionCaption = 'New,ApprovalPending,Canceled,Approved';
            OptionMembers = New,ApprovalPending,Canceled,Approved;

            trigger OnValidate()
            begin
                TETimeSheet.Reset;
                TETimeSheet.SetRange("Document No.", TimesheetLines.Timesheetcode);
                TETimeSheet.SetRange(Status, TimesheetLines.Status::Approved);
                if TETimeSheet.FindFirst then begin
                    Status := Status::Approved;
                end;
            end;
        }
        field(50010; Entry; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Employee No", Date)
        {
            Clustered = true;
        }
        key(Key2; "User ID", "Week Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*CALCFIELDS("Day 1 Status","Day 2 Status","Day 3 Status","Day 4 Status","Day 5 Status","Day 6 Status","Day 7 Status");
        CheckDays;
        
        TETimeSheet.SETRANGE("User ID","User ID");
        TETimeSheet.SETRANGE("Week Start Date","Week Start Date");
        IF TETimeSheet.FINDSET THEN BEGIN
        IF TETimeSheet.COUNT = 1 THEN BEGIN
          TETimeSheetStatus."User ID" := "User ID";
          TETimeSheetStatus."Week Start Date" := "Week Start Date";
          TETimeSheetStatus.DELETE(TRUE);
        END;
        END;*/
        //GLTranManagement.DeleteLineDistributionBuffer("Internal Control No.");

    end;

    trigger OnInsert()
    var
        TimesheetHeader: Record TimesheetLines;

    begin

        if TimesheetHeader.Get(Rec."Document No.") then begin
            "Employee No" := TimesheetHeader."Employee No";
        end;


    end;


    trigger OnModify()
    begin
        /*
        TESTFIELD("User ID");
        
        TETimeSheet.SETRANGE("Entry No.","Entry No.");
        TETimeSheet.FINDFIRST;
        
        {IF "User ID" <> TETimeSheet."User ID" THEN
          ERROR(TEText002);}
        
        TETimeSheet.CALCFIELDS("Day 1 Status","Day 2 Status","Day 3 Status","Day 4 Status","Day 5 Status",
          "Day 6 Status","Day 7 Status");
        CALCFIELDS("Day 1 Status","Day 2 Status","Day 3 Status","Day 4 Status","Day 5 Status","Day 6 Status","Day 7 Status");
        
        IF ((Description <> TETimeSheet.Description) OR
           ("Time Type Code" <> TETimeSheet."Time Type Code") OR
           ("Global Dimension 1 Code" <> TETimeSheet."Global Dimension 1 Code") OR
           ("Global Dimension 2 Code" <> TETimeSheet."Global Dimension 2 Code") OR
           ("Global Dimension 3 Code" <> TETimeSheet."Global Dimension 3 Code") OR
           ("Global Dimension 4 Code" <> TETimeSheet."Global Dimension 4 Code") OR
           ("Global Dimension 5 Code" <> TETimeSheet."Global Dimension 5 Code") OR
           ("Global Dimension 6 Code" <> TETimeSheet."Global Dimension 6 Code") OR
           ("Global Dimension 7 Code" <> TETimeSheet."Global Dimension 7 Code") OR
           ("Global Dimension 8 Code" <> TETimeSheet."Global Dimension 8 Code") OR
           ("Fund No." <> TETimeSheet."Fund No.") OR
           ("Dimension Speedkey Code" <> TETimeSheet."Dimension Speedkey Code")) THEN BEGIN
          CheckDays;
        END;
        
        IF ("Day 1" <> TETimeSheet."Day 1") THEN BEGIN
          IF ("Day 1 Status" <> "Day 1 Status"::New)THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 2" <> TETimeSheet."Day 2") THEN BEGIN
          IF ("Day 2 Status" <> "Day 2 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 3" <> TETimeSheet."Day 3") THEN BEGIN
          IF ("Day 3 Status" <> "Day 3 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 4" <> TETimeSheet."Day 4") THEN BEGIN
          IF ("Day 4 Status" <> "Day 4 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 5" <> TETimeSheet."Day 5") THEN BEGIN
          IF ("Day 5 Status" <> "Day 5 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 6" <> TETimeSheet."Day 6") THEN BEGIN
          IF ("Day 6 Status" <> "Day 6 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        IF ("Day 7" <> TETimeSheet."Day 7") THEN BEGIN
          IF ("Day 7 Status" <> "Day 7 Status"::New) THEN BEGIN
            ERROR(TEText001);
          END;
        END;
        
        TestRequiredFields;
        
        IF "Internal Control No." = '' THEN BEGIN
          "Internal Control No." := GLTranManagement.GenerateICN;
        END;
        //TETimeMgt.GenDistBufferTimeSheet(Rec);
        */

    end;

    var
        TEText001: label 'Cannot change hours unless Day Status is New.';
        TEText002: label 'Cannot change User ID. You must delete the line instead.';
        TEText003: label 'Cannot modify unless Day Status is New.';
        TEText004: label 'Fund %1 is blocked. ';
        Employee: Record "HR Employees";
        DimValues: Record "Dimension Value";
        TX001: label 'You can''t have Project & Leave Timesheet on the same line';
        TimeControl: Decimal;
        TX002: label 'Timesheet Shouldn''t Exceed 8 hours';
        Usersetup: Record "User Setup";
        Hrs: Decimal;
        Employee6: Record Employee;
        Usersetup6: Record "User Setup";
        TETimeSheet: Record "TE Time Sheet1";
        Leave: Record "HR Leave Types";
        TimesheetLines: Record TimesheetLines;


    procedure GetNextEntryNo(): Integer
    begin

        TETimeSheet.Reset;
        TETimeSheet.SetCurrentkey("Line No.");
        if TETimeSheet.FindLast then
            exit(TETimeSheet.Entry + 100)
        else
            exit(100);
    end;


    procedure CheckDays()
    begin
        /*IF (("Day 1 Status" <> "Day 1 Status"::"0") AND ("Day 1" <> 0)) OR
           (("Day 2 Status" <> "Day 2 Status"::"0") AND ("Day 2" <> 0)) OR
           (("Day 3 Status" <> "Day 3 Status"::"0") AND ("Day 3" <> 0)) OR
           (("Day 4 Status" <> "Day 4 Status"::"0") AND ("Day 4" <> 0)) OR
           (("Day 5 Status" <> "Day 5 Status"::"0") AND ("Day 5" <> 0)) OR
           (("Day 6 Status" <> "Day 6 Status"::"0") AND ("Day 6" <> 0)) OR
           (("Day 7 Status" <> "Day 7 Status"::"0") AND ("Day 7" <> 0)) THEN BEGIN
          ERROR(TEText003);
        END;
        */

    end;


    procedure UpdateDefaults()
    var
        UserSetup: Record "User Setup";
        Employee: Record Employee;
    begin
        /*
        IF UserSetup.GET("User ID") THEN BEGIN
        
        IF Employee.READPERMISSION THEN BEGIN
          IF UserSetup."Employee No." <> '' THEN BEGIN
            Employee.GET(UserSetup."Employee No.");
            IF "Fund No." = '' THEN
              "Fund No." := Employee."Fund No.";
            IF "Global Dimension 1 Code" = '' THEN
              "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
            IF "Global Dimension 2 Code" = '' THEN
              "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
            IF "Global Dimension 3 Code" = '' THEN
              "Global Dimension 3 Code" := Employee."Global Dimension 3 Code";
            IF "Global Dimension 4 Code" = '' THEN
              "Global Dimension 4 Code" := Employee."Global Dimension 4 Code";
            IF "Global Dimension 5 Code" = '' THEN
              "Global Dimension 5 Code" := Employee."Global Dimension 5 Code";
            IF "Global Dimension 6 Code" = '' THEN
              "Global Dimension 6 Code" := Employee."Global Dimension 6 Code";
            IF "Global Dimension 7 Code" = '' THEN
              "Global Dimension 7 Code" := Employee."Global Dimension 7 Code";
            IF "Global Dimension 8 Code" = '' THEN
              "Global Dimension 8 Code" := Employee."Global Dimension 8 Code";
          END;
          IF ("Fund No." = '') AND (UserSetup."Fund No." <> '') THEN BEGIN
            "Fund No." := UserSetup."Fund No.";
          END;
        END;
        END
        */

    end;


    procedure TestRequiredFields()
    begin
        //TESTFIELD("Time Type Code");
    end;


    procedure SetSourceCode(): Code[10]
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        /*
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup."Time Entry");
        EXIT(SourceCodeSetup."Time Entry");
        */

    end;
}

