//
//  CacheManagerTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class CacheManagerTests: XCTestCase {

    private var sut: CacheManager!
    private let testKey = "test_key"
    private let testObject = TestCacheObject(id: 1, name: "test", value: 42)

    override func setUp() {
        super.setUp()
        sut = CacheManager.shared
        // Clear any existing cache
        sut.clear()
    }

    override func tearDown() {
        // Clean up after each test
        sut.clear()
        sut = nil
        super.tearDown()
    }

    // MARK: - Set and Get Tests
    func testSetAndGetObject() {
        sut.set(testObject, forKey: testKey)

        let retrievedObject = sut.get(testKey, type: TestCacheObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.id, testObject.id)
        XCTAssertEqual(retrievedObject?.name, testObject.name)
        XCTAssertEqual(retrievedObject?.value, testObject.value)
    }

    func testGetNonExistentObject() {
        let retrievedObject = sut.get("non_existent_key", type: TestCacheObject.self)

        XCTAssertNil(retrievedObject)
    }

    func testSetAndGetString() {
        let testString = "Hello, World!"
        sut.set(testString, forKey: testKey)

        let retrievedString = sut.get(testKey, type: String.self)

        XCTAssertEqual(retrievedString, testString)
    }

    func testSetAndGetInt() {
        let testInt = 42
        sut.set(testInt, forKey: testKey)

        let retrievedInt = sut.get(testKey, type: Int.self)

        XCTAssertEqual(retrievedInt, testInt)
    }

    func testSetAndGetArray() {
        let testArray = [1, 2, 3, 4, 5]
        sut.set(testArray, forKey: testKey)

        let retrievedArray = sut.get(testKey, type: [Int].self)

        XCTAssertEqual(retrievedArray, testArray)
    }

    func testSetAndGetComplexObject() {
        let complexObject = ComplexTestObject(
            basicObject: testObject,
            array: [testObject, TestCacheObject(id: 2, name: "test2", value: 84)],
            dictionary: ["key1": "value1", "key2": "value2"],
            optionalValue: nil
        )

        sut.set(complexObject, forKey: testKey)

        let retrievedObject = sut.get(testKey, type: ComplexTestObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.basicObject.id, complexObject.basicObject.id)
        XCTAssertEqual(retrievedObject?.array.count, complexObject.array.count)
        XCTAssertEqual(retrievedObject?.dictionary, complexObject.dictionary)
        XCTAssertNil(retrievedObject?.optionalValue)
    }

    func testSetAndGetEmptyString() {
        let emptyString = ""
        sut.set(emptyString, forKey: testKey)

        let retrievedString = sut.get(testKey, type: String.self)

        XCTAssertEqual(retrievedString, emptyString)
    }

    func testSetAndGetEmptyArray() {
        let emptyArray: [Int] = []
        sut.set(emptyArray, forKey: testKey)

        let retrievedArray = sut.get(testKey, type: [Int].self)

        XCTAssertEqual(retrievedArray, emptyArray)
    }

    // MARK: - Remove Tests
    func testRemoveObject() {
        sut.set(testObject, forKey: testKey)

        // Verify object is cached
        XCTAssertNotNil(sut.get(testKey, type: TestCacheObject.self))

        sut.remove(testKey)

        // Verify object is removed
        XCTAssertNil(sut.get(testKey, type: TestCacheObject.self))
    }

    func testRemoveNonExistentObject() {
        // Should not crash
        sut.remove("non_existent_key")

        // Verify nothing happens
        XCTAssertNil(sut.get("non_existent_key", type: TestCacheObject.self))
    }

    func testRemoveMultipleObjects() {
        let key1 = "key1"
        let key2 = "key2"
        let key3 = "key3"

        sut.set(testObject, forKey: key1)
        sut.set("test string", forKey: key2)
        sut.set(42, forKey: key3)

        // Verify all objects are cached
        XCTAssertNotNil(sut.get(key1, type: TestCacheObject.self))
        XCTAssertNotNil(sut.get(key2, type: String.self))
        XCTAssertNotNil(sut.get(key3, type: Int.self))

        sut.remove(key1)
        sut.remove(key2)

        // Verify specific objects are removed
        XCTAssertNil(sut.get(key1, type: TestCacheObject.self))
        XCTAssertNil(sut.get(key2, type: String.self))
        XCTAssertNotNil(sut.get(key3, type: Int.self)) // This should still exist
    }

    // MARK: - Clear Tests
    func testClearCache() {
        let key1 = "key1"
        let key2 = "key2"
        let key3 = "key3"

        sut.set(testObject, forKey: key1)
        sut.set("test string", forKey: key2)
        sut.set(42, forKey: key3)

        // Verify all objects are cached
        XCTAssertNotNil(sut.get(key1, type: TestCacheObject.self))
        XCTAssertNotNil(sut.get(key2, type: String.self))
        XCTAssertNotNil(sut.get(key3, type: Int.self))

        sut.clear()

        // Verify all objects are cleared
        XCTAssertNil(sut.get(key1, type: TestCacheObject.self))
        XCTAssertNil(sut.get(key2, type: String.self))
        XCTAssertNil(sut.get(key3, type: Int.self))
    }

    func testClearEmptyCache() {
        // Should not crash
        sut.clear()

        // Verify still works after clearing empty cache
        sut.set(testObject, forKey: testKey)
        XCTAssertNotNil(sut.get(testKey, type: TestCacheObject.self))
    }

    // MARK: - Cache Validity Tests
    func testIsCacheValid_FreshCache() {
        sut.set(testObject, forKey: testKey)

        let isValid = sut.isCacheValid(forKey: testKey, maxAge: 60) // 1 minute

        XCTAssertTrue(isValid)
    }

    func testIsCacheValid_NonExistentCache() {
        let isValid = sut.isCacheValid(forKey: "non_existent_key", maxAge: 60)

        XCTAssertFalse(isValid)
    }

    func testIsCacheValid_ExpiredCache() {
        sut.set(testObject, forKey: testKey)

        // Manually set cache time to past
        let pastTime = Date().timeIntervalSince1970 - 120 // 2 minutes ago
        UserDefaults.standard.set(pastTime, forKey: "cache_time_" + testKey)

        let isValid = sut.isCacheValid(forKey: testKey, maxAge: 60) // 1 minute max age

        XCTAssertFalse(isValid)
    }

    func testIsCacheValid_EdgeCase_ZeroMaxAge() {
        sut.set(testObject, forKey: testKey)

        let isValid = sut.isCacheValid(forKey: testKey, maxAge: 0)

        XCTAssertFalse(isValid) // Even fresh cache should be invalid with 0 max age
    }

    func testIsCacheValid_EdgeCase_NegativeMaxAge() {
        sut.set(testObject, forKey: testKey)

        let isValid = sut.isCacheValid(forKey: testKey, maxAge: -1)

        XCTAssertFalse(isValid) // Should be invalid with negative max age
    }

    func testIsCacheValid_LargeMaxAge() {
        sut.set(testObject, forKey: testKey)

        let isValid = sut.isCacheValid(forKey: testKey, maxAge: TimeInterval.greatestFiniteMagnitude)

        XCTAssertTrue(isValid) // Should be valid with very large max age
    }

    // MARK: - Overwrite Tests
    func testOverwriteObject() {
        let originalObject = TestCacheObject(id: 1, name: "original", value: 10)
        let newObject = TestCacheObject(id: 2, name: "new", value: 20)

        sut.set(originalObject, forKey: testKey)

        let retrievedOriginal = sut.get(testKey, type: TestCacheObject.self)
        XCTAssertEqual(retrievedOriginal?.name, "original")

        sut.set(newObject, forKey: testKey)

        let retrievedNew = sut.get(testKey, type: TestCacheObject.self)
        XCTAssertEqual(retrievedNew?.name, "new")
        XCTAssertEqual(retrievedNew?.id, 2)
        XCTAssertEqual(retrievedNew?.value, 20)
    }

    // MARK: - Edge Cases
    func testSetObjectWithEmptyKey() {
        let emptyKey = ""
        sut.set(testObject, forKey: emptyKey)

        let retrievedObject = sut.get(emptyKey, type: TestCacheObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.id, testObject.id)
    }

    func testSetObjectWithSpecialCharactersInKey() {
        let specialKey = "key!@#$%^&*()_+-=[]{}|;':\",./<>?"
        sut.set(testObject, forKey: specialKey)

        let retrievedObject = sut.get(specialKey, type: TestCacheObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.id, testObject.id)
    }

    func testSetObjectWithLongKey() {
        let longKey = String(repeating: "a", count: 1000)
        sut.set(testObject, forKey: longKey)

        let retrievedObject = sut.get(longKey, type: TestCacheObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.id, testObject.id)
    }

    func testSingletonBehavior() {
        let instance1 = CacheManager.shared
        let instance2 = CacheManager.shared

        XCTAssertTrue(instance1 === instance2)

        // Set value with first instance
        instance1.set(testObject, forKey: testKey)

        // Get value with second instance
        let retrievedObject = instance2.get(testKey, type: TestCacheObject.self)

        XCTAssertNotNil(retrievedObject)
        XCTAssertEqual(retrievedObject?.id, testObject.id)
    }

    // MARK: - Cache Constants Tests
    func testCacheKeyConstants() {
        XCTAssertEqual(CacheManager.CacheKey.pokemonList, "pokemon_list")
        XCTAssertEqual(CacheManager.CacheKey.pokemonDetail, "pokemon_detail_")
    }

    func testCacheMaxAgeConstants() {
        XCTAssertEqual(CacheManager.CacheMaxAge.pokemonList, 24 * 60 * 60) // 24 hours
        XCTAssertEqual(CacheManager.CacheMaxAge.pokemonDetail, 7 * 24 * 60 * 60) // 7 days
    }
}

// MARK: - Test Objects
private struct TestCacheObject: Codable, Equatable {
    let id: Int
    let name: String
    let value: Int
}

private struct ComplexTestObject: Codable {
    let basicObject: TestCacheObject
    let array: [TestCacheObject]
    let dictionary: [String: String]
    let optionalValue: String?
}
