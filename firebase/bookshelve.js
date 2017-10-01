/**
 * @author Thiago Mallon <thiagomallon@gmail.com>
 */
window.addEventListener('load', function() {

    (function() {
        var body = document.body;
        var screen = document.createElement("div");
        screen.setAttribute("id", "screen");
        screen.setAttribute("style", "padding: 1em; height: 1.4em; border-radius: 1em; min-width: 6em; background: #000; position:fixed; top:2%; right:2%;");
        var screenLabel = document.createTextNode("Pos: ");
        screen.appendChild(screenLabel);

        var posScreen = document.createElement("span");
        posScreen.setAttribute("id", "pos-screen");
        var posScreenLabel = document.createTextNode("0");
        posScreen.appendChild(posScreenLabel);

        var breakLine = document.createElement("br");

        screen.appendChild(posScreen);
        screen.appendChild(breakLine);
        screen.appendChild(breakLine);

        // prepend screen to the beginning of theParent
        body.insertBefore(screen, body.firstChild);
    })();

    var book = null;

    (function() {
        var path = document.location.pathname;
        var sPath = path.split('/');
        book = sPath[sPath.length - 2];
        book = book.replace(/\%20/g, ' ');
        book = book.replace(/\./g, ' ');
        // console.log(book);
    })();

    (function() {
        var config = {
            apiKey: "",
            authDomain: "",
            databaseURL: "",
            storageBucket: "",
            messagingSenderId: ""
        };
        firebase.initializeApp(config);
        firebase.auth().signInWithEmailAndPassword('', '')
            .catch(function(error) {
                // Handle Errors here.
                var errorCode = error.code;
                var errorMessage = error.message;
                if (errorCode === 'auth/wrong-password') {
                    alert('Wrong password.');
                } else {
                    alert(errorMessage);
                }
                console.log(error);
            });
        getPos();
    })();

    var delay;

    function delayingUpdate() {
        delay = setTimeout(function() {
            setPos();
        }, 1000);
    }

    function delayingClear() {
        clearTimeout(delay);
    }

    function createBook() {
        var updates = {};
        updates["/books/" + book + "/created"] = new Date();
        updates["/books/" + book + "/reading-progress"] = '0';
        firebase.database().ref().update(updates);
    }

    function getPos() {
        firebase.database().ref("/books/" + book + "/reading-progress").once('value').then(function(snapshot) {
            // console.log('Position: ' + snapshot.val());
            if (snapshot.val()) {
                document.body.scrollTop = snapshot.val();
            } else {
                createBook();
            }
        });
    };

    function setPos() {
        var updates = {};
        // var accessId = firebase.database().ref().child("/books/" + book + "/accesses/").push().key;
        var accessId = new Date();
        updates["/books/" + book + "/accesses/" + accessId + "/progress"] = document.body.scrollTop;
        updates["/books/" + book + "/accesses/" + accessId + "/time"] = new Date();
        updates["/books/" + book + "/accesses/" + accessId + "/user-agent"] = navigator.userAgent;
        updates["/books/" + book + "/reading-progress"] = document.body.scrollTop;
        firebase.database().ref().update(updates);
    }

    var lastSelection = null;
    document.addEventListener("mouseup", function(e) {
        var selection = document.getSelection().toString();
        if (selection && selection !== lastSelection) {
            lastSelection = selection;
            var updates = {};
            var highId = firebase.database().ref().child("/books/" + book + "/highlights/").push().key;
            // var highId = new Date();
            // updates["/books/" + book + "/highlights/" + highId] = selection;
            updates["/books/" + book + "/highlights/" + selection.replace(/\./g, ' ')] = '2t';
            firebase.database().ref().update(updates);
        };
    });

    document.addEventListener("scroll", function() {
        document.getElementById("pos-screen").innerHTML = document.body.scrollTop;
        delayingClear();
        delayingUpdate();
    });
});
