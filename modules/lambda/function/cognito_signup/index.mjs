export const handler  = (event, context, callback) => {
    const emailArr=['choinamja306@gmail.com','cseongmin458@gmail.com','wotjr990204@gmail.com', 'rlatmdwn0702@gmail.com','zldifld@gmail.com'];
    console.log(event.request.userAttributes);
    if(!emailArr.includes(event.request.userAttributes.email)){
        const error = new Error("Cannot register users with this email");
        callback(error,event);
    }
    callback(null,event);
};