const StarNotary = artifacts.require('StarNotary')

contract('StarNotary', accounts => { 

    beforeEach(async function() { 
        this.contract = await StarNotary.new({from: accounts[0]})
    })
    
    describe('can create a star', () => { 
        
        let starId = 1;
        
        
        it('cannot create a star with non-unique coordinates', async function() {
            let starId2 = 2;
            await this.contract.createStar('some Star!', starId, "dec_121.874", "mag_245.978", "ra_032.155", "I love my wonderful star", {from: accounts[0]});
            let err = null

            try {
                await this.contract.createStar('some other Star!', starId2, "dec_121.874", "mag_245.978", "ra_032.155", "Another wonderful star",  {from: accounts[0]})
            } catch(error) {
                err = error
            }

            assert.ok(err instanceof Error)
            
        })

        it('can create a star and get its name', async function () { 
            
            await this.contract.createStar('awesome Star!',  starId, "dec_123", "mag_309", "ra_010.107", "I love my wonderful star", {from: accounts[0]})
            var star = await this.contract.tokenIdToStar(starId)
            assert.equal(star[0], 'awesome Star!')
         
        })


        
    })
    
    describe('buying and selling stars', () => { 
        let user1 = accounts[1]
        let user2 = accounts[2]
        let randomMaliciousUser = accounts[3]
        
        let starId = 1
        let starPrice = web3.toWei(.01, "ether")

        beforeEach(async function () { 
            await this.contract.createStar('awesome Star!', starId, "dec_123", "mag_309", "ra_010.107", "I love my wonderful star", {from: user1})    
        })
        
        it('user1 can put up their star for sale', async function () { 
            assert.equal(await this.contract.ownerOf(starId), user1)
            await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
            
            assert.equal(await this.contract.starsForSale(starId), starPrice)
        })
        
        describe('user2 can buy a star that was put up for sale', () => { 
            beforeEach(async function () { 
                await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
            })

            it('user2 is the owner of the star after they buy it', async function() { 
                await this.contract.buyStar(starId, {from: user2, value: starPrice, gasPrice: 0})
                assert.equal(await this.contract.ownerOf(starId), user2)
            })

            it('user2 ether balance changed correctly', async function () { 
                let overpaidAmount = web3.toWei(.05, 'ether')
                const balanceBeforeTransaction = web3.eth.getBalance(user2)
                await this.contract.buyStar(starId, {from: user2, value: overpaidAmount, gasPrice: 0})
                const balanceAfterTransaction = web3.eth.getBalance(user2)

                assert.equal(balanceBeforeTransaction.sub(balanceAfterTransaction), starPrice)
            })
        })
    })


    describe('getting appropiate star info', () => {
        let user1 = accounts[0]
        let starId = 1;
        let starInfo = ['awesome Star!', "I love my wonderful star", "ra_010.107", "dec_123", "mag_309"]

        beforeEach(async function() {
            await this.contract.createStar('awesome Star!', starId, "dec_123", "mag_309", "ra_010.107", "I love my wonderful star", {from: user1})
        })

        it('gets star info for appropiate id', async function() {
            var star = await this.contract.tokenIdToStarInfo(starId);
            assert.equal(star[0], starInfo[0]);
            assert.equal(star[1], starInfo[1]);
            assert.equal(star[2], starInfo[2]);
            assert.equal(star[3], starInfo[3]);
            assert.equal(star[4], starInfo[4]);
        })


    })
})