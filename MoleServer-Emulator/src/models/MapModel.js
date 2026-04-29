class MapModel {
    constructor() {
        this.maps = new Map();
    }

    getUsersByMap(mapID, userModel) {
        if (!this.maps.has(mapID)) {
            this.maps.set(mapID, []);
        }
        // Xóa những user bị kẹt (không online nữa)
        const currentUsers = this.maps.get(mapID);
        const validUsers = currentUsers.filter(u => userModel.getUser(u.userID) !== undefined);
        this.maps.set(mapID, validUsers);
        return validUsers;
    }

    addUserToMap(user, newMapID, userModel) {
        const validUsers = this.getUsersByMap(newMapID, userModel);
        if (!validUsers.find(u => u.userID === user.userID)) {
            validUsers.push(user);
        }
        this.maps.set(newMapID, validUsers);
    }

    removeUserFromMap(user, userModel) {
        const oldMapID = user.map;
        if (!oldMapID) return null;
        
        const mapUsers = this.getUsersByMap(oldMapID, userModel);
        const updatedUsers = mapUsers.filter(u => u.userID !== user.userID);
        
        this.maps.set(oldMapID, updatedUsers);
        return mapUsers; // Trả về danh sách cũ để broadcast
    }
}

module.exports = new MapModel();
