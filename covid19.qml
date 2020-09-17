import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtCharts 2.3


/*Window {
    id: window
    visible: true
    title: qsTr("Hello World")

    ChartView{
        title: "Stacked Bar series"
        anchors.fill: parent
        legend.alignment: Qt.AlignBottom
        antialiasing: true

        BarSeries {
            id: mySeries
            axisX: BarCategoryAxis { categories: ["2007", "2008", "2009", "2010", "2011", "2012" ] }
            BarSet { label: "Kraj"; values: ["7","3","5"] }
        }
    }*/
Rectangle{
    Column{
        anchors.fill: parent
        spacing: 6

    Button {
        id: requestButton
        text: "API"
        onClicked: {
           request();
        }
    }
    Label{
        id: datum
        width: 100
        height: 100
        fontSizeMode: Text.Fit
        minimumPointSize: 9
        font.pointSize: 24
         anchors.right: parent.right
    }
  }

   function request() {
       var url = 'https://api.sledilnik.org/api/municipalities';
       var doc = new XMLHttpRequest();
       var res;
       doc.onreadystatechange = function() {
             var datumi = parseJson(doc.responseText);
             return datumi;
       };
       doc.open('GET', url, true);
       doc.send('');
   }


   function parseJson(podatki){
       var data = [];
       try{
       data = JSON.parse(podatki);
       }catch(e){
       }

       var izbran = "celje";
       var kraj = izbran;
       var potrjenih = 0;
       var max = 0;
       var datumi = [];
       var okuzeni =[];
       var n = data.length-1;
         for(var k = 0; k < n;k++){
         var regije = Object.values(data[k].regions);
         for(var i = 0;i<regije.length;i++){
           var obcina = regije[i];
           var mesto = Object.values(obcina);
           for(var j = 0;j <mesto.length;j++){
             if(Object.keys(obcina)[j]===kraj){
              potrjenih=mesto[j].confirmedToDate;
              if(potrjenih>max){
                max = potrjenih;
              datumi.push(data[k].day+"."+data[k].month);
              okuzeni.push(max);
              }
            }
           }
         }
        }
         datum.text = max;
         return datumi;
   }
}
