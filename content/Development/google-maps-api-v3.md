# Google Maps API v3
Sobre boas maneiras para se trablhar com Google Maps API v3, com base nos conhecimento aprendidos no projeto AgroPro.

###### Entendendo o Maps
A Api da google fornece soluções para diversas áreas, ou seja, ele não é apenas um mapa, é uma ferramenta que pode ser utilizada desde fornecimento de rotas e marcadores, até analises geográfias mais complexas.

- [Todas as APIs](https://developers.google.com/maps/documentation/?hl=pt-br)

**Layers**
A maneira encontrada para solucionar grande parte das questões de Agro, foi trabalhar com Layers (Camadas).

- [Layers](https://developers.google.com/maps/documentation/javascript/layers?hl=pt-br)
- [DataLayer](https://developers.google.com/maps/documentation/javascript/datalayer)

Foi escolhido trabalhar dessa maneira devido ao suporte a KML e GeoRSS, o que deixa a integração com outros softwares de tecnologia espacial mais fácil, pois a maioria trabalha dessa maneira, importando, e exportando esse tipo de arquivos.
Além do mais, trabalhar com layers torna sua aplicação muito mais escalável, tendo em vista que cada camada possue um objeto diferente, assim, não acontecendo conflitos entre camadas e objetos.

###### KML

**Importando um polygon**

```
var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 11,
            center: {lat: 41.876, lng: -87.624}
          });

var ctaLayer = new google.maps.KmlLayer({
  url: 'http://googlemaps.github.io/js-v2-samples/ggeoxml/cta.kml',
  map: map
});
```

###### Elementos do Maps e as Layers (Polygons, polylines, rectangles e markers)

**Polygon**

Neste exemplo, multiplus polygons são inseridos em uma única camada, possibilitando o controle de cada camada individualmente.

```
// This example uses the Google Maps JavaScript API's Data layer
// to create a rectangular polygon with 2 holes in it.

var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 6,
            center: {lat: -33.872, lng: 151.252},
          });
// Define the LatLng coordinates for the outer path.

var outerCoords = [
  {lat: -32.364, lng: 153.207}, // north west
  {lat: -35.364, lng: 153.207}, // south west
  {lat: -35.364, lng: 158.207}, // south east
  {lat: -32.364, lng: 158.207}  // north east
];

// Define the LatLng coordinates for an inner path.
var innerCoords1 = [
  {lat: -33.364, lng: 154.207},
  {lat: -34.364, lng: 154.207},
  {lat: -34.364, lng: 155.207},
  {lat: -33.364, lng: 155.207}
];

// Define the LatLng coordinates for another inner path.
var innerCoords2 = [
  {lat: -33.364, lng: 156.207},
  {lat: -34.364, lng: 156.207},
  {lat: -34.364, lng: 157.207},
  {lat: -33.364, lng: 157.207}
];

map.data.add({geometry: new google.maps.Data.Polygon([outerCoords,
                                                      innerCoords1,
                                                      innerCoords2])})
```
