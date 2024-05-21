
# SPARQL Queries

## Creator types in dblp {#creator-types-in-dblp}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?type (COUNT(?type) AS ?count) WHERE {
  ?subject rdf:type dblp:Creator .
  ?subject rdf:type ?type .
  FILTER( ?type != dblp:Creator )
}
GROUP BY ?type
ORDER BY DESC(?count)
```

<a class="run" href="https://sparql.dblp.org/t4dF0g" target="_blank" />

:::


## Publication types in dblp {#publication-types-in-dblp}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?type (COUNT(?type) AS ?count) WHERE {
  ?subject rdf:type dblp:Publication .
  ?subject rdf:type ?type .
  FILTER( ?type != dblp:Publication )
}
GROUP BY ?type
ORDER BY DESC(?count)
```

<a class="run" href="https://sparql.dblp.org/tLfR7u" target="_blank" />

:::


## Citation types in dblp+OCC {#citation-types-in-dblpocc}

::: {.example .marker}

```sparql
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?type (COUNT(?type) AS ?count) WHERE {
  ?subject rdf:type cito:Citation .
  ?subject rdf:type ?type .
}
GROUP BY ?type
ORDER BY DESC(?count)
```

<a class="run" href="https://sparql.dblp.org/1FF7rR" target="_blank" />

:::


## ID schemes linked in dblp {#id-schemes-linked-in-dblp}

::: {.example .marker}

```sparql
PREFIX datacite: <http://purl.org/spar/datacite/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?scheme ?type (COUNT(DISTINCT ?id) as ?count_scheme) WHERE {
  ?item datacite:hasIdentifier ?id .
  ?id datacite:usesIdentifierScheme ?scheme .
  ?id rdf:type ?type .
  FILTER (?scheme != datacite:dblp-record && ?scheme != datacite:dblp)
}
GROUP BY ?scheme ?type
ORDER BY DESC(?count_scheme)
LIMIT 10
```

<a class="run" href="https://sparql.dblp.org/tSkthy" target="_blank" />

:::


## Most cited authors in dblp {#most-cited-authors-in-dblp}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?author ?name (SUM(?count_cite) as ?cites) WHERE {
  { SELECT ?publ (COUNT(DISTINCT ?cite) as ?count_cite) WHERE { 
    ?publ dblp:omid ?omid .
    ?cite cito:hasCitedEntity ?omid .
  } GROUP BY ?publ }
  ?publ dblp:authoredBy ?author .
  ?author rdfs:label ?name .
}
GROUP BY ?author ?name
ORDER BY DESC(?cites)
LIMIT 10
```

<a class="run" href="https://sparql.dblp.org/KHGO1Q" target="_blank" />

:::


## Most cited publications in dblp {#most-cited-publications-in-dblp}

::: {.example .marker}

```sparql
PREFIX schema: <https://schema.org/>
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <https://schema.org/>
SELECT ?url ?publ ?title (COUNT(?citation) as ?cites) WHERE {
  ?citation rdf:type cito:Citation .
  ?citation cito:hasCitedEntity ?omid .
  ?publ rdf:type dblp:Publication .
  ?publ dblp:omid ?omid .
  ?publ rdfs:label ?title .
  ?omid schema:url ?url
}
GROUP BY ?url ?publ ?title
ORDER BY DESC(?cites)
```

<a class="run" href="https://sparql.dblp.org/ePAtFp" target="_blank" />

:::


## Theses in dblp by school {#theses-in-dblp-by-school}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?school (COUNT(DISTINCT ?thesis) as ?count) WHERE {
  ?thesis rdf:type dblp:Book .
  ?thesis dblp:thesisAcceptedBySchool ?school .
}
GROUP BY ?school
ORDER BY DESC(?count)
```

<a class="run" href="https://sparql.dblp.org/sXUHeT" target="_blank" />

:::


##  Journal Impact Factors in 2019-2023 {#journal-impact-factors}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT ?venue (COUNT(DISTINCT ?publ) as ?publs) (COUNT(DISTINCT ?citation) as ?cites)
      ((COUNT(DISTINCT ?citation)/COUNT(DISTINCT ?publ)) AS ?impact) WHERE {
  ?publ rdf:type dblp:Article .
  ?publ dblp:omid ?omid .
  ?publ dblp:publishedIn ?venue .
  ?publ dblp:yearOfPublication ?year .
  FILTER(?year >= "2019"^^xsd:gYear) . 
  OPTIONAL { ?citation cito:hasCitedEntity ?omid }
}
GROUP BY ?venue
ORDER BY DESC(?impact)
LIMIT 25
```

<a class="run" href="https://sparql.dblp.org/kLl2Pu" target="_blank" />

:::


## Most cited publications with title keyword "dblp" {#most-cited-publications-with-title-keyword-dblp}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX schema: <https://schema.org/>
SELECT ?url ?publ ?label (COUNT(?citation) as ?cites) WHERE {
  ?publ rdf:type dblp:Publication .
  ?publ dblp:title ?title .
  FILTER CONTAINS(?title, "dblp") .
  ?publ dblp:omid ?omid .
  ?publ rdfs:label ?label .
  ?citation rdf:type cito:Citation .
  ?citation cito:hasCitedEntity ?omid .
  ?omid schema:url ?url .
}
GROUP BY ?url ?publ ?label
ORDER BY DESC(?cites)
LIMIT 10
```

<a class="run" href="https://sparql.dblp.org/9062it" target="_blank" />

:::


## Most cited publications from Dagstuhl Publishing {#most-cited-publications-from-dagstuhl-publishing}

::: {.example .marker}

```sparql
PREFIX dblp: <https://dblp.org/rdf/schema#>
PREFIX cito: <http://purl.org/spar/cito/>
PREFIX datacite: <http://purl.org/spar/datacite/>
PREFIX litre: <http://purl.org/spar/literal/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?publ ?label (COUNT(DISTINCT ?cite) as ?count_cite) WHERE {
  ?publ a dblp:Publication .
  ?publ datacite:hasIdentifier ?id .
  ?id datacite:usesIdentifierScheme datacite:doi .
  ?id litre:hasLiteralValue ?doistr .
  FILTER REGEX(?doistr,"^10.4230/") .
  ?publ dblp:omid ?omid .
  ?cite cito:hasCitedEntity ?omid .
  ?publ rdfs:label ?label .
}
GROUP BY ?publ ?label
ORDER BY DESC(?count_cite)
LIMIT 10
```

<a class="run" href="https://sparql.dblp.org/RztfOs" target="_blank" />

:::
