var Billboard = artifacts.require("./Billboard.sol");

contract('Billboard', function(accounts) {

    //Test constructor
    it("Test Contract", ()=>
    {
        return Billboard.new( 16 )
            .then(function(instance) {

                instance.totalSupply().then((supply) => {
                    assert.equal(supply.valueOf(), 16, "Adspace total is 16");
                }).catch((error) => {
                    process.stdout.write(error.toString() + "\n");
                });

                instance.name().then((name) => {
                    assert.equal(name, "Billboard", "Token name is called Billboard");
                }).catch((error) => {
                    process.stdout.write(error.toString() + "\n");
                });

                instance.symbol().then((name) => {
                    assert.equal(name, "BB", "Token symbol is called BB");
                }).catch((error) => {
                    process.stdout.write(error.toString() + "\n");
                });

                //Get Space
                instance.getAdSpace(4).then((results) => {
                    assert.equal(results[0].toNumber(), 4, "AdSpace 0 should have id 0");
                    assert.equal(results[1], accounts[0], "AdSpace 0 should belong to 0");
                    assert.equal(results[2], true, "AdSpace 4 should not be for sale");
                    assert.equal(results[3], 0, "AdSpace 0 price should be 0");
                }).catch((error) => {
                    process.stdout.write(error.toString() + "\n");
                });

                //Get Space
                instance.getAdSpace(0).then((results) => {
                    assert.equal(results[0].toNumber(), 0, "AdSpace 0 should have id 0");
                    assert.equal(results[1], accounts[0], "AdSpace 0 should belong to 0");
                    assert.equal(results[2], true, "AdSpace 0 should not be for sale");
                    assert.equal(results[3], 0, "AdSpace 0 price should be 0");
                }).catch((error) => {
                    process.stdout.write(error.toString() + "\n");
                });


                //Buy space
                instance.sellAdspace(1, 2).then((results) => {
                    instance.buySpace(1, {from: accounts[1], value: 2}).then((results) => {
                        instance.getAdSpace(1).then((results) => {
                            assert.equal(results[0].toNumber(), 1, "AdSpace 1 should have id 1");
                            assert.equal(results[1], accounts[1], "AdSpace 1 should belong to accounts 1");
                            assert.equal(results[2], false, "AdSpace 1 should not be for sale");
                            assert.equal(results[3], 0, "AdSpace 1 price should be 0");
                        });

                        instance.updateAd(1, "account[1] title", "account[1] owns this!", {from: accounts[1]}).then((results=>{
                            instance.getAd(1).then((results)=>{
                                assert.equal(results[0].toNumber(), 1, "id incorrect");
                                assert.equal(results[1], "account[1] title", "Ad title is incorrect");
                                assert.equal(results[2], "account[1] owns this!", "Ad text is incorrect");
                            });
                        }));

                        //Free transfer
                        instance.transferSpace(0, accounts[2]).then(()=>{
                            instance.balanceOf(accounts[2]).then((balance)=>{
                                assert.equal(balance.valueOf(), 1, "accounts[2] should have 1 tokens");
                                instance.balanceOf(accounts[0]).then((balance)=>{
                                    assert.equal(balance.valueOf(), 14, "accounts[2] should have 1 tokens");
                                });
                            });
                        }).catch((error)=>{
                            process.stdout.write(error.toString() + "\n");
                        });

                    }).catch((error) => {
                        process.stdout.write(error.toString() + "\n");
                    });
                });


                //Buy space and update
                instance.sellAdspace(5, 1).then((results) => {
                    instance.buySpace(5, "account[3] title", "account[3] owns this!", {from: accounts[3], value: 1}).then((results) => {
                        instance.getAdSpace(5).then((results) => {
                            assert.equal(results[0].toNumber(), 5, "AdSpace 5 should have id 5");
                            assert.equal(results[1], accounts[3], "AdSpace 5 should belong to accounts 5");
                            assert.equal(results[2], false, "AdSpace 1 should not be for sale");
                            assert.equal(results[3], 0, "AdSpace 1 price should be 0");
                        });
                    }).catch((error) => {
                        process.stdout.write(error.toString() + "\n");
                    });
                });

            });
    });


});
