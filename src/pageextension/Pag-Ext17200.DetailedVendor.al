pageextension 17200 DetailedVendor extends "Detailed Vendor Ledg. Entries"
{
    layout
    {

    }
    // trigger OnAfterGetRecord()
    // var
    //     UserSetup: Record "User Setup";
    //     Vendor: Record Vendor;
    // begin
    //     Vendor.Reset();
    //     Vendor.SetRange(Vendor."No.", Rec."Vendor No.");

    //     if Vendor.Find('-') then begin
    //         if Vendor."Special Account" = true then
    //             UserSetup.Reset();
    //         UserSetup.SetRange("User ID", UserId);
    //         if UserSetup.Find('-') then begin
    //             if UserSetup."View Special Accounts" = false then begin
    //                 Error('You are not allowed to view this account');
    //             end;
    //         end;
    //     end;
    // end;


}
