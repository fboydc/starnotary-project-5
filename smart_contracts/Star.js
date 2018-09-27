class Star {
    constructor(id, name, story){
        this.id = id;
        this.name = name;
        this.story = story;
        this.dec = '';
        this.mag = '';
        this.cent = '';
    }

    setCoordinates(dec, mag, cent){
        this.dec = dec;
        this.mag = mag;
        this.cent = cent;
    }

    getCoordinates(){
        let coords = this.dec + ", "+ this.mag+", "+this.cent;
        return coords;
    }


}