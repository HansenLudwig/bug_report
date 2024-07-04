using {sap.capire.bookshop as my} from '../db/schema';

service CatalogService @(path: '/browse') {

  @readonly
  @cds.redirection.target
  entity Books   as
    projection on my.Books {
      *,
      ID          as bookID,
      author.name as author_name,
    // author.ID   as author_ID
    }
    excluding {
      createdBy,
      modifiedBy
    };


  @readonly
  @cds.redirection.target
  entity Authors as
    projection on my.Authors {
      *,
      ID   as authorID,
      name as authorName,
    };

  // @requires: 'authenticated-user'
  action submitOrder(book : Books:ID, quantity : Integer);

}

extend entity CatalogService.Books with actions {
  @(Common.SideEffects: {
    SourceProperties: ['in/author_ID'],
    TargetProperties: []
  })
  action show_bug(in : $self,
                  @mandatory
                  @(
                    title:'Bug here: @UI.Importance:#High is not acting as expected',
                    Common:{
                      ValueListWithFixedValues: true,
                      ValueList               : {
                        CollectionPath: 'Authors',
                        Parameters    : [
                          {
                            $Type            : 'Common.ValueListParameterInOut',
                            ValueListProperty: 'authorName',
                            LocalDataProperty: authorName,
                            @UI.Importance   : #High
                          },
                          // ISSUE:
                          // @UI.Importance   : #High
                          //   this should work to hide other columns according to
                          //   https://sapui5.hana.ondemand.com/sdk/#/topic/a5608eabcc184aee99e1a7d88b28816c.html
                          {
                            $Type            : 'Common.ValueListParameterOut', // This is not working correctly in value helps.
                            // $Type            : 'Common.ValueListParameterDisplayOnly',
                            ValueListProperty: 'authorID',
                            LocalDataProperty: author_ID,
                            // @UI.Importance   : #High // This should hide this column and only show the `authorName` in the value help.
                          }
                        ]
                      }
                    },
                  )
                  authorName : String(111),
                  @UI.Hidden
                  author_ID : Integer);
}
