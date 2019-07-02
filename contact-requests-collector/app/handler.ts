import {ContactRequestsDao} from "./dao";
import {Notifier} from "./notify";

export const handler = async (contactRequest: ContactRequestModel): Promise<any> => {
    console.log(JSON.stringify(contactRequest, null, 2));
    return ContactRequestsDao
        .put('contact-requests', contactRequest)
        .then(() => Notifier.notify(contactRequest));
};


