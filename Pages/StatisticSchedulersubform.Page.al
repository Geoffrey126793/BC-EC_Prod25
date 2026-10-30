page 8001317 "Statistic Scheduler subform"
{
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Statistic Scheduler subform

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Statistic Scheduler line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Statistic code"; "Statistic code")
                {
                }
                field(Name; Name)
                {
                }
                field("User ID"; "User ID")
                {
                    LookupPageID = Users;
                }
                field("Type of Treatment"; "Type of Treatment")
                {
                }
                field("Process from date"; "Process from date")
                {
                }
                field("Process to date"; "Process to date")
                {
                }
                field("Detail level"; "Detail level")
                {
                }
                field("Print definition"; "Print definition")
                {
                }
                field("Print total"; "Print total")
                {
                }
                field("File Name"; "File Name")
                {

                }
                field("Excel sheet"; "Excel sheet")
                {

                    trigger OnAssistEdit()
                    var
                        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
                    begin
                        //"Excel sheet" := StatsExplorerTools.SelectSheetsName("File Name");
                    end;
                }
                field("Save Excel file"; "Save Excel file")
                {
                }
                field("Close Excel file"; "Close Excel file")
                {
                }
                field("Archive Excel File"; "Archive Excel File")
                {
                    Description = '#8489';
                }
                field(PathArchiveExcelFile; "Path Archive Excel File")
                {

                }
            }
        }
    }

    actions
    {
    }

    [Scope('OnPrem')]
    procedure Users()
    var
        UsersList: Record "Statistic User";
        UsersForm: Page "Statistic Users List";
    begin
        UsersList.SetRange("Sheduler code", "Code treatment");
        UsersList.SetRange("Statistic code", "Statistic code");
        PAGE.RunModal(8001322, UsersList);
    end;
}

