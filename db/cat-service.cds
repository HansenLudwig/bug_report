using { sap.capire.bookshop as my } from '../db/schema';

service CatalogService @(path:'/browse') { 

  @readonly
  @cds.redirection.target
  entity Books as projection on my.Books {
    *,
    ID as bookID,
    author.name as author_name,
  } excluding { createdBy, modifiedBy };


  @readonly
  @cds.redirection.target
  entity Authors as projection on my.Authors {
    *,
    ID as authorID,
    name as authorName,
  };

  // @requires: 'authenticated-user'
  action submitOrder (book: Books:ID, quantity: Integer);

}

extend entity CatalogService.Books with actions {
  @(Common.SideEffects: {
    SourceProperties: [
      'in/author_ID'
    ],
    TargetProperties: []
  })
  action show_bug( in: $self,
    @mandatory
    @(
      title:'Bug here:',
      Common:{
          ValueListWithFixedValues: true,
          ValueList               : {
          CollectionPath: 'Authors',
          Parameters : [
            {
              $Type            : 'Common.ValueListParameterInOut',
              ValueListProperty: 'authorName',
              LocalDataProperty: authorName
            },
            {
              $Type            : 'Common.ValueListParameterDisplayOnly',
              ValueListProperty: 'authorID',
            }
          ]
        }
      },
    )
    authorName: String(111),
    @mandatory
    @(
      title:'Date',
    ) date : Date
  );
}