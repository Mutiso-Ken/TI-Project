#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50038 "Appraisal Report"
{
    RDLCLayout = 'Layouts/Appraisal Report.rdlc';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Appraisal Header"; "Appraisal Header")
        {

            column(Appraisal_Code; "Appraisal Header"."Appraisal Code") { }
            column(Start_Date; "Appraisal Header"."Start Date") { }
            column(End_Date; "Appraisal Header"."End Date") { }
            column(Full_Name; "Appraisal Header"."Employee Name") { }
            column(Department; "Appraisal Header"."Employee Deparment") { }
            column(Job_Title; "Appraisal Header"."Job Title") { }
            column(Supervisor_Name; "Appraisal Header"."Supervisor Name") { }
            column(Overall_Score; "Appraisal Header"."Overall Score") { }
            column(Part_A; "Appraisal Header"."Part A") { }
            column(Part_C; "Appraisal Header"."Part C") { }
            column(Part_D; "Appraisal Header"."Part D") { }
            column(General_Appraiser_Comments; "Appraisal Header"."General Appraiser Comments") { }
            column(Employee_Comments; "Appraisal Header"."Employee Comments") { }
            column(Observer_Comments; "Appraisal Header"."General Appraiser Comments") { }
            column(Head_Comments; "Appraisal Header"."Head Comments") { }
            column(ED_Comments; "Appraisal Header"."ED Comments") { }
            column(SignatureBase64; SignatureBase64) { }
            column(mimeType; mimeType) { }
            column(CompanyINfoName; CompanyINfo.Name) { }
            column(CompanyINfoAdd; CompanyINfo.Address) { }
            column(CompanyINfoPicture; CompanyINfo.Picture) { }

            dataitem("Appraisal Lines Section A Part A"; "Appraisal Lines Section A")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Section = const("Part A"));

                column(RowType_SecA_PartA; 'SEC_A_PART_A') { }
                column(What_have_you_done; "Appraisal Lines Section A Part A"."What have you done") { }
                column(When; "Appraisal Lines Section A Part A"."When?") { }
                column(Expected_Results; "Appraisal Lines Section A Part A"."Expected Results") { }
                column(What_was_Achieved_; "Appraisal Lines Section A Part A"."What was Achieved?") { }
                column(Supervisor_Rating; "Appraisal Lines Section A Part A"."Supervisor Rating") { }

            }
            dataitem("Appraisal Lines Section A Part B"; "Appraisal Lines Section A")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Section = const("Part B"));

                column(RowType_SecA_PartB; 'SEC_A_PART_B') { }
                column(Capacity_Needed; "Appraisal Lines Section A Part B"."Capacity Needed") { }
                column(Why_Prioritize; "Appraisal Lines Section A Part B"."Why Prioritize") { }
                column(Comments_by_the_supervisor; "Appraisal Lines Section A Part B"."Comments by the supervisor") { }
            }
            dataitem("Appraisal Lines Section B Part 1"; "Appraisal Lines Section B")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 1"));

                column(RowType_SecB_Part1; 'SEC_B_PART_1') { }
                column(Section_B_Question_Description_Part_1; "Appraisal Lines Section B Part 1"."Question Description") { }
                column(Section_B_Self_Appraisal_Part_1; "Appraisal Lines Section B Part 1"."Self-appraisal (Comments)") { }
                column(Section_B_Supervisor_Comments_Part_1; "Appraisal Lines Section B Part 1"."Comments by the supervisor") { }
            }
            dataitem("Appraisal Lines Section B Part 2"; "Appraisal Lines Section B")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 2"));

                column(RowType_SecB_Part2; 'SEC_B_PART_2') { }
                column(Section_B_Question_Description_Part_2; "Appraisal Lines Section B Part 2"."Question Description") { }
                column(Section_B_Self_Appraisal_Part_2; "Appraisal Lines Section B Part 2"."Self-appraisal (Comments)") { }
                column(Section_B_Supervisor_Comments_Part_2; "Appraisal Lines Section B Part 2"."Comments by the supervisor") { }
            }
            dataitem("Appraisal Lines Section B Part 3"; "Appraisal Lines Section B")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 3"));

                column(RowType_SecB_Part3; 'SEC_B_PART_3') { }
                column(Section_B_Question_Description_Part_3; "Appraisal Lines Section B Part 3"."Question Description") { }
                column(Section_B_Self_Appraisal_Part_3; "Appraisal Lines Section B Part 3"."Self-appraisal (Comments)") { }
                column(Section_B_Supervisor_Comments_Part_3; "Appraisal Lines Section B Part 3"."Comments by the supervisor") { }
            }
            dataitem("Appraisal Lines Section B Part 4"; "Appraisal Lines Section B")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 4"));

                column(RowType_SecB_Part4; 'SEC_B_PART_4') { }
                column(Section_B_Question_Description_Part_4; "Appraisal Lines Section B Part 4"."Question Description") { }
                column(Section_B_Self_Appraisal_Part_4; "Appraisal Lines Section B Part 4"."Self-appraisal (Comments)") { }
                column(Section_B_Supervisor_Comments_Part_4; "Appraisal Lines Section B Part 4"."Comments by the supervisor") { }
            }
            dataitem("Appraisal Lines Section C Part 1"; "Appraisal Lines Section C")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 1"));

                column(RowType_SecC_Part1; 'SEC_C_PART_1') { }
                column(Section_C_Question_Part_1; "Appraisal Lines Section C Part 1".Question) { }
                column(Section_C_Self_Rating_Part_1; "Appraisal Lines Section C Part 1"."Self Rating") { }
                column(Section_C_Supervisor_Rating_Part_1; "Appraisal Lines Section C Part 1"."Supervisor Rating") { }
                column(Section_C_Supervisor_Comment_Part_1; "Appraisal Lines Section C Part 1"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section C Part 2"; "Appraisal Lines Section C")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 2"));

                column(RowType_SecC_Part2; 'SEC_C_PART_2') { }
                column(Section_C_Question_Part_2; "Appraisal Lines Section C Part 2".Question) { }
                column(Section_C_Self_Rating_Part_2; "Appraisal Lines Section C Part 2"."Self Rating") { }
                column(Section_C_Supervisor_Rating_Part_2; "Appraisal Lines Section C Part 2"."Supervisor Rating") { }
                column(Section_C_Supervisor_Comment_Part_2; "Appraisal Lines Section C Part 2"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section C Part 3"; "Appraisal Lines Section C")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 3"));

                column(RowType_SecC_Part3; 'SEC_C_PART_3') { }
                column(Section_C_Question_Part_3; "Appraisal Lines Section C Part 3".Question) { }
                column(Section_C_Self_Rating_Part_3; "Appraisal Lines Section C Part 3"."Self Rating") { }
                column(Section_C_Supervisor_Rating_Part_3; "Appraisal Lines Section C Part 3"."Supervisor Rating") { }
                column(Section_C_Supervisor_Comment_Part_3; "Appraisal Lines Section C Part 3"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section C Part 4"; "Appraisal Lines Section C")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 4"));

                column(RowType_SecC_Part4; 'SEC_C_PART_4') { }
                column(Section_C_Question_Part_4; "Appraisal Lines Section C Part 4".Question) { }
                column(Section_C_Self_Rating_Part_4; "Appraisal Lines Section C Part 4"."Self Rating") { }
                column(Section_C_Supervisor_Rating_Part_4; "Appraisal Lines Section C Part 4"."Supervisor Rating") { }
                column(Section_C_Supervisor_Comment_Part_4; "Appraisal Lines Section C Part 4"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section C Part 5"; "Appraisal Lines Section C")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 5"));

                column(RowType_SecC_Part5; 'SEC_C_PART_5') { }
                column(Section_C_Question_Part_5; "Appraisal Lines Section C Part 5".Question) { }
                column(Section_C_Self_Rating_Part_5; "Appraisal Lines Section C Part 5"."Self Rating") { }
                column(Section_C_Supervisor_Rating_Part_5; "Appraisal Lines Section C Part 5"."Supervisor Rating") { }
                column(Section_C_Supervisor_Comment_Part_5; "Appraisal Lines Section C Part 5"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section D Part 1"; "Appraisal Lines Section D")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 1"));

                column(RowType_SecD_Part1; 'SEC_D_PART_1') { }
                column(Section_D_Question_Part_1; "Appraisal Lines Section D Part 1".Question) { }
                column(Section_D_Supervisor_Rating_Part_1; "Appraisal Lines Section D Part 1"."Supervisor Rating") { }
                column(Section_D_Supervisor_Comment_Part_1; "Appraisal Lines Section D Part 1"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section D Part 2"; "Appraisal Lines Section D")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 2"));

                column(RowType_SecD_Part2; 'SEC_D_PART_2') { }
                column(Section_D_Question_Part_2; "Appraisal Lines Section D Part 2".Question) { }
                column(Section_D_Supervisor_Rating_Part_2; "Appraisal Lines Section D Part 2"."Supervisor Rating") { }
                column(Section_D_Supervisor_Comment_Part_2; "Appraisal Lines Section D Part 2"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section D Part 3"; "Appraisal Lines Section D")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 3"));

                column(RowType_SecD_Part3; 'SEC_D_PART_3') { }
                column(Section_D_Question_Part_3; "Appraisal Lines Section D Part 3".Question) { }
                column(Section_D_Supervisor_Rating_Part_3; "Appraisal Lines Section D Part 3"."Supervisor Rating") { }
                column(Section_D_Supervisor_Comment_Part_3; "Appraisal Lines Section D Part 3"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section D Part 4"; "Appraisal Lines Section D")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 4"));

                column(RowType_SecD_Part4; 'SEC_D_PART_4') { }
                column(Section_D_Question_Part_4; "Appraisal Lines Section D Part 4".Question) { }
                column(Section_D_Supervisor_Rating_Part_4; "Appraisal Lines Section D Part 4"."Supervisor Rating") { }
                column(Section_D_Supervisor_Comment_Part_4; "Appraisal Lines Section D Part 4"."Supervisor Comment") { }
            }
            dataitem("Appraisal Lines Section D Part 5"; "Appraisal Lines Section D")
            {
                DataItemLink = "Appraisal Code" = field("Appraisal Code");
                DataItemTableView = where(Part = const("Part 5"));

                column(RowType_SecD_Part5; 'SEC_D_PART_5') { }
                column(Section_D_Question_Part_5; "Appraisal Lines Section D Part 5".Question) { }
                column(Section_D_Supervisor_Rating_Part_5; "Appraisal Lines Section D Part 5"."Supervisor Rating") { }
                column(Section_D_Supervisor_Comment_Part_5; "Appraisal Lines Section D Part 5"."Supervisor Comment") { }
            }
            trigger OnPreDataItem();
            begin
            end;

            trigger OnAfterGetRecord();
            var
                TenantMedia: Record "Tenant Media";
                MediaId: Guid;
                InStr: InStream;
            begin
                Clear(SignatureBase64);
                Clear(mimeType);

                if "Appraisee Signature".Count > 0 then begin
                    MediaId := "Appraisee Signature".Item(1);
                    if TenantMedia.Get(MediaId) then begin
                        TenantMedia.CalcFields(Content);
                        if TenantMedia.Content.HasValue then begin
                            TenantMedia.Content.CreateInStream(InStr);
                            SignatureBase64 := Base64Convert.ToBase64(InStr);
                            mimeType := TenantMedia."Mime Type";
                        end;
                    end;
                end;
            end;

        }
    }

    trigger OnPreReport()

    begin
        CompanyINfo.Get;
        CompanyINfo.CalcFields(Picture);
    end;


    var
        CompanyINfo: Record "Company Information";
        Base64Convert: Codeunit "Base64 Convert";
        SignatureBase64: Text;
        mimeType: Text;
        AppraisalHeader2: Record "Appraisal Header";

    trigger OnInitReport();
    begin

    end;

}