exports.init = async function(app) {
    app.ports.jsonify.subscribe(async (obj) => {
        console.log("jsonify!");
        const jsonStr = JSON.stringify(obj);
        console.log(jsonStr);
        app.ports.returnJsonStr.send(jsonStr);
    });
}
