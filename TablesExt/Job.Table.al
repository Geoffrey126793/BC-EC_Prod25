tableextension 50027 JobEC extends Job
{
    fields
    {
        field(8001301; "Criteria 1"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(91);
            Caption = 'Criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001301));
        }
        field(8001302; "Criteria 2"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(92);
            Caption = 'Criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001302));
        }
        field(8001303; "Criteria 3"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(93);
            Caption = 'Criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001303));
        }
        field(8001304; "Criteria 4"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(94);
            Caption = 'Criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001304));
        }
        field(8001305; "Criteria 5"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(95);
            Caption = 'Criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001305));
        }
        field(8001306; "Criteria 6"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(96);
            Caption = 'Criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001306));
        }
        field(8001307; "Criteria 7"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(97);
            Caption = 'Criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001307));
        }
        field(8001308; "Criteria 8"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(98);
            Caption = 'Criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001308));
        }
        field(8001309; "Criteria 9"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(99);
            Caption = 'Criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001309));
        }
        field(8001310; "Criteria 10"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(100);
            Caption = 'Criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001310));
        }
    }
    var
        wStatisticAggregate: record "Statistic aggregate";
}

