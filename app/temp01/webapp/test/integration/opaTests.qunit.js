sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'bugreport/temp01/test/integration/FirstJourney',
		'bugreport/temp01/test/integration/pages/BooksList',
		'bugreport/temp01/test/integration/pages/BooksObjectPage'
    ],
    function(JourneyRunner, opaJourney, BooksList, BooksObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('bugreport/temp01') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBooksList: BooksList,
					onTheBooksObjectPage: BooksObjectPage
                }
            },
            opaJourney.run
        );
    }
);