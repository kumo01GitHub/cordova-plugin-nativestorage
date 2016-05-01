/* jshint jasmine: true */
/* global NativeStorage */
exports.defineAutoTests = function () {
    
    describe('Write/Read Tests', function () {
        it('Objects', function (done) {
            var dummyData = { data1: "", data2: 2, data3: 3.0 };
            NativeStorage.set("dummy_ref_obj",
                dummyData,
                function (result) {
                    NativeStorage.getObject("dummy_ref_obj",
                        function (result) {
                            expect(result).toEqual(dummyData);
                            done();
                        },
                        function (e) {
                            fail("Read Object Failed");
                        });
                },
                function (e) {
                    fail("Write Object Failed");
                });

        });
    });

};