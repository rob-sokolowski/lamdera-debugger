exports.init = async function(app) {
    app.ports.jsonify.subscribe(async (obj) => {
        console.log("jsonify!");
        console.log(JSON.stringify(obj));
    });
}
