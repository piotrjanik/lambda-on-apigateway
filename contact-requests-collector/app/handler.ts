import {ContactRequestsDao} from "./dao";

export const handler = async (event: any = {}): Promise<any> => {
    console.log(JSON.stringify(event, null, 2));
    return ContactRequestsDao.put('contact-requests', event);
};


