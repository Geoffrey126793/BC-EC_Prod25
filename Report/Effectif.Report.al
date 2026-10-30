report 50095 Effectif
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Effectif.rdlc';
    UsageCategory = Lists;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Blocked = CONST(false), "Production BOM No." = FILTER(<> ''));
            RequestFilterFields = "No.";
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(Version; Version)
            {
            }
            dataitem("ABC - Parametres"; "ABC - Parametres")
            {
                DataItemTableView = WHERE("Imputation Ressource" = CONST(Direct), Activity = FILTER(<> 'S*'), "Nombre d'opérateurs" = FILTER(> 0));
                column(Activity_ABCParametres; "ABC - Parametres".Activity)
                {
                }
                column("Nombredopérateurs_ABCParametres"; "ABC - Parametres"."Nombre d'opérateurs")
                {
                }
                column(Activitydescription_ABCParametres; "ABC - Parametres"."Activity description")
                {
                }
                column(Ressource_desc; "ABC - Parametres"."Ressource description")
                {
                }
                column(NetOutput; "ABC - Parametres"."Rendement effectif")
                {
                }

                trigger OnPreDataItem()
                begin

                    "ABC - Parametres".SetRange("Production BOM No", Item."Production BOM No.");
                    "ABC - Parametres".SetRange("BOM Version", Version);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Version := VersionMgt.GetBOMVersion(Item."Production BOM No.", Today, false);
            end;

            trigger OnPreDataItem()
            begin
                if not Item.IsMfgItem then
                    CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        VersionMgt: Codeunit VersionManagement;
        Version: Code[20];
}

