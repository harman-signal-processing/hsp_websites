// == NOTE ==
// This code uses ES6 promises. If you want to use this code in a browser
// that doesn't supporting promises natively, you'll have to include a polyfill.

gapi.analytics.ready(function () {
    //  This will be the list of charts to show
    var chartsToShowList = [];
    var lastItemKey = harmanSitesAnalyticInfo[Object.keys(harmanSitesAnalyticInfo)[Object.keys(harmanSitesAnalyticInfo).length - 1]].elementIdSuffix;
    var totalNumOfAccounts = Object.keys(harmanSitesAnalyticInfo).length;
    var currentNumOfAccountsLoaded = 0;

    var secondsUntilNextUpdate = 60;

    var timeUntilNextUpdateCounter = new Countdown({
        seconds: secondsUntilNextUpdate,  // number of seconds to count down
        onUpdateStatus: function (sec)
        {
            //$(".Titles-sub").html("Next update in <span id='tickSeconds'>" + sec + "</span> seconds. <div id='stopTimer'>Stop timer</div> | <div id='startTimer'>Start timer</div>");
            $(".Titles-sub").html("Next update in <span id='tickSeconds'>" + sec + "</span> seconds.");
            //console.log(sec);
        }, // callback for each second
        onCounterEnd: function ()
        {
            //alert('counter ended!');
            loadUpTheChartToShowList();
        } // final action
    });


    $(document.body).on('click', "#stopTimer", function () { timeUntilNextUpdateCounter.stop(); });
    $(document.body).on('click', "#startTimer", function () { timeUntilNextUpdateCounter.start(); });

    $(document).on("alldataloaded",
        function (event) {
            sortChartList();
            timeUntilNextUpdateCounter.start();
        });  //  $(document).on("alldataloaded"

    function loadUpTheChartToShowList()
    {
        currentNumOfAccountsLoaded = 0;

        //  Get the key names from the harmanSitesAnalytics object and add them to the chartsToShowList
        for (var key in harmanSitesAnalyticInfo) {
            harmanSitesAnalyticInfo.hasOwnProperty(key) && chartsToShowList.push(key);
        }

        //  Start the chart loading process with the first chart in the list
        createRealtimeItems(chartsToShowList.shift(0), chartsToShowList);
    }  //  function loadUpTheChartToShowList()

    //  run intial chart load
    loadUpTheChartToShowList();

    function createRealtimeItems(siteName, chartsToShowList) {
        var siteGAInfo = harmanSitesAnalyticInfo[siteName];
        
        $(".Titles-sub").html("List will be sorted when updating is complete. Updating: <b>" + siteName + "</b>.");

        //  call realtime api
        gapi.client.analytics.data.realtime
                .get({ ids: "ga:" + siteGAInfo.view.id, metrics: 'rt:activeUsers' })  // .get
                .execute(function (response)
                {
                    var newValue = response.totalResults ? +response.rows[0][0] : 0;

                    var listItemIsAlreadyOnPage = $("#realtimeList li[data-sitename='" + siteName + "']").length == 1;
                    listItemIsAlreadyOnPage ? updateItemHtml(siteName, newValue) : insertItemIntoHtml(siteName, newValue);
                    currentNumOfAccountsLoaded++;
                    
                    if (totalNumOfAccounts === currentNumOfAccountsLoaded)
                    {
                        $.event.trigger({ type: "alldataloaded", message: "all data loaded", time: new Date() });
                    }

                });  //  gapi.client.analytics.data.realtime.execute(function (response)



        //  wait 1 second then update or insert the next item
        setTimeout(
            function ()
            {
                chartsToShowList.length > 0 && createRealtimeItems(chartsToShowList.shift(0), chartsToShowList);
            }
            , 1000);  // setTimeout

    };  //  function createRealtimeItems(siteName, chartsToShowList)

    

    function Countdown(options) {
        var timer,
        instance = this,
        seconds = options.seconds || 10,
        updateStatus = options.onUpdateStatus || function () { },
        counterEnd = options.onCounterEnd || function () { };

        function decrementCounter() {
            updateStatus(seconds);
            if (seconds === 0) {
                counterEnd();
                instance.stop();
            }
            seconds--;
        }

        this.start = function () {
            clearInterval(timer);
            timer = 0;
            seconds = options.seconds;
            timer = setInterval(decrementCounter, 1000);
        };

        this.stop = function () {
            clearInterval(timer);
        };
    }  //  function Countdown(options)


    function insertItemIntoHtml(siteName, value) {
        var siteGAInfo = harmanSitesAnalyticInfo[siteName];
        var $realtimeList = $("#realtimeList");

        var $li = $("<li style='display:none;'></li>").addClass("FlexGrid-item").attr("data-sitename", siteName).attr("data-activeusercount", value);
        var $div = $("<div></div>").addClass("ActiveUsers").html(siteName + ": <b class='ActiveUsers-value'>" + value + "</b>");
        $li.append($div);

        $realtimeList.append($li);
        $li.show("slow");
        $div.addClass("is-increasing");

    }  //  function insertItemIntoHtml()

    function updateItemHtml(siteName, value) {
        var siteGAInfo = harmanSitesAnalyticInfo[siteName];
        var $li = $("#realtimeList li[data-sitename='" + siteName + "']");
        var $div = $li.find("div");

        var oldValue = parseInt($li.attr("data-activeusercount"));
        var newValue = parseInt(value);

        //  remove old highlight
        $div.removeClass("is-increasing").removeClass("is-decreasing").removeClass("is-same");

        //  add new highlight
        newValue > oldValue ? $div.addClass("is-increasing") : newValue === oldValue ? $div.addClass("is-same") : $div.addClass("is-decreasing");

        //  set the new value
        $li.attr("data-activeusercount", value);
        $li.find("b").text(value);
    }  //  function updateItemHtml()

    function sortChartList() {
        var ul = $('#realtimeList'),
            li = ul.children('li');
        var count = 1;

        li.detach().sort(function (a, b)
        {
            var aName = $(a).attr('data-sitename');
            var aNum = Number($(a).attr('data-activeusercount'));

            var bName = $(b).attr('data-sitename');
            var bNum = Number($(b).attr('data-activeusercount'));


            //  return $(a).data('sortby') - $(b).data('sortby'); // asc
            var returnValue = Number(bNum - aNum);

            //console.log((count++) + " | " + returnValue + " --- " + bName + ":" + bNum + " - " + aName + ":" + aNum);

            return returnValue;  //  desc
        });

        ul.append(li);

        //callback();

        
    };  //  function sortChartList()

    console.table(realtimeList);
});  //  gapi.analytics.ready(function ()