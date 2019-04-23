$(document).on('turbolinks:load', function () {
    window.cookieconsent.initialise({
        "palette": {
            "popup": {
                "background": "#06070b"
            },
            "button": {
                "background": "#3a67e8"
            }
        },
        "theme": "classic",
        "content": {
            "message": "Tento web používa súbory cookie na poskytovanie služieb a analýzu webu. Používaním tohto webu vyjadrujete svoj súhlas s používaním súborov cookie.",
            "dismiss": "OK"
        },
        "showLink": false
    })
});
