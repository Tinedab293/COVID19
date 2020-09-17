import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtCharts 2.3
import  QtQml 2.12


Window {
    id: window
    visibility: "FullScreen"
    visible: true
    title: qsTr("QTCovid19")

    ChartView {
        title: "Covid19"
        anchors.fill: parent
        legend.visible: false
        antialiasing: true

        ScatterSeries {
            id: series1
            axisX: BarCategoryAxis {
                            id:barAxis
            }
            axisY: ValueAxis {
                            id:axisY
                            min: 0
                        }
           }
    }

    Row{
        id: inputField
        anchors{
            top: parent.top; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10
        }
        spacing: 6
        Pane {
            anchors.left: parent.left
            background: Rectangle {
                color: "#eeeeee"
            }
        Label{
            id: datum
            text: "0"
            }
        }

        ComboBox {
            id: dropDown
             anchors.right: parent.right
            width: 400
            editable: true
            model: ListModel {
                id: model
            }
            onAccepted: {
                pocisti();
                request(editText);
            }

        }
        Component.onCompleted: {
            requestKraji();
        }
    }



   function request(tekst) {
       var url = 'https://api.sledilnik.org/api/municipalities';
       var doc = new XMLHttpRequest();
       var res;
       doc.onreadystatechange = function() {
             var datumi = parseJson(doc.responseText,tekst);
             return datumi;
       };
       doc.open('GET', url, true);
       doc.send();
   }
   function requestKraji() {
       var url = 'https://api.sledilnik.org/api/municipalities';
       var doc = new XMLHttpRequest();
       doc.onreadystatechange = function() {
                fillKraji(doc.responseText);
       };
       doc.open('GET', url, true);
       doc.send('');
   }
   function fillKraji(podatki){
        var data = [];
        try{
        data = JSON.parse(podatki);
        }catch(e){
        }
        var kraji=[];
        var n = data.length-1;
          var regije = Object.values(data[n-1].regions);
          for(var i = 0;i<regije.length;i++){
            var obcina = regije[i];
            var mesto = Object.values(obcina);
            for(var j = 0;j <mesto.length;j++){
                kraji.push(Object.keys(obcina)[j]);
             }
            }
          dropDown.model=kraji;
    }

   function parseJson(podatki,tekst){
       var data = [];
       try{
       data = JSON.parse(podatki);
       }catch(e){

       }

       var izbran = tekst;
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
         datum.text = "There have been "+max+" confirmed cases in "+kraj+" so far";
         series1.axisX.categories = datumi;
         series1.axisX.max = datumi.length;
         series1.axisY.max = max+1;
         for (var d = 1; d < okuzeni.length; d++) {
             series1.append(d, okuzeni[d]);
         }
         return datumi;
   }
   function pocisti(){
       series1.clear()
   }
}
