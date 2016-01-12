# floating-headers-in-Visualforce-PageBlockTable

Very often we build tables in Visualforce that contains large amounts of data. When the data types are very similar users can sometimes get confused when they scroll to the areas of the table when they can’t see the table headers anymore. When the data is very similar (for example when we have many columns with numeric values) the users might have to scroll all the way back to the top to see field is each column.

 

One possible solution to this problem is to add pagination to the table. Another possible and easier solution is to make the headers of the table float as the user scrolls down so they’re always visible.

 

Floating Header on PageBlockTable

 

This is done by adding a little bit of jQuery to our Visualforce pages. There’s a lot you can do when you add jQuery to your Visualforce pages, you can make your pages much more interactive and they will work much smoother than the standard Visualforce rendering functionality. The downside of using jQuery is that Salescforce don’t support any testing framework for it. Salesforce can also change how they create their Visualforce component which could cause your feature to break and the without automated tests you wouldn’t get an alert your feature is broken. Therefor it’s highly recommended to use selenium tests for your jQuery features but that’s for another post.

 

In order to make the headers of a PageBlockTable to float you’ll first need to add jQuery to your page. You can add the jQuery file to your static resources and call it from there on your Visualforce page. Then, you’ll also need to add another javascript file with 2 methods that will help make the headers of the visualforce table to float

 
```
function stickHeader(tableId, headerClass) {
  var stickyHeaderTop = jQuery('table[id$='+ tableId + '] > thead').offset().top;
  var tableBottomPosition = jQuery('table[id$='+ tableId + ']').offset().top + jQuery('table[id$='+ tableId + ']').outerHeight(true) - jQuery('table[id$='+ tableId + '] > thead').height();
  window.addEventListener("scroll", function(){
    if(jQuery(window).scrollTop() > stickyHeaderTop && jQuery(window).scrollTop() < tableBottomPosition) {
      setColumnWidthEqualToDisplayed(headerClass);
      var headerRowWidth = jQuery('table[id$='+ tableId + '] > thead').width();
      jQuery('table[id$='+ tableId + '] > thead').css({position: 'fixed', top: '0px', width: headerRowWidth});
    } else {
      jQuery('table[id$='+ tableId + '] > thead ').css({position: 'static', top: '0px'});
    }
  });
}

function setColumnWidthEqualToDisplayed(headerClass) {
  jQuery('.' + headerClass).each(function( index ) {
     var columnWidth = jQuery(this).width();
     jQuery(this).css({width : columnWidth});
  });
}
```

The stickHeader method would be the method we would call from our Visualforce page. We would put that Javascript file in our static resources and name it StickHeader.js.

 

Now in every page we would like to make one (or more) of the PageBlockTables to have floating headers we would need to call the jQuery static resource, our StickHeader static resource, give our pageBlockTables some Id, give each table header a custom CSS class and call our stickHeader method with the PageBlockTable Id and the CSS class we gave to each of its header.

 
```
<apex:page controller="DummyController">
    <script src="{!URLFOR($Resource.jQuery)}"></script>
    <script src="{!URLFOR($Resource.StickHeader)}"></script>
    <script type="text/javascript">
        $.noConflict();
        jQuery(document).ready(function() {
            stickHeader('recordsTable', 'headerClass');
            stickHeader('anotherRecordsTable', 'anotherHeaderClass');
        });
    </script>
    <apex:pageBlock >
        <apex:pageBlockTable value="{!records}" var="record" id="recordsTable">
            <apex:column headerValue="Name" headerClass="headerClass">
                <apex:outputText value="{!record.Name}"/>
            </apex:column>
            <apex:column headerValue="Phone" headerClass="headerClass">
                <apex:outputText value="{!record.Phone}" />
            </apex:column>
        </apex:pageBlockTable>
    </apex:pageBlock>
    <apex:pageBlock >
        <apex:pageBlockTable value="{!records}" var="record" id="anotherRecordsTable">
            <apex:column headerValue="Name" headerClass="anotherHeaderClass">
                <apex:outputText value="{!record.Name}"/>
            </apex:column>
            <apex:column headerValue="Id" headerClass="anotherHeaderClass">
                <apex:outputText value="{!record.Id}" />
            </apex:column>
        </apex:pageBlockTable>
    </apex:pageBlock>
</apex:page>
```