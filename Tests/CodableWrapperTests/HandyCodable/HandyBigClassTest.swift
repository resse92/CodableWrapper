//
//  File.swift
//  
//
//  Created by resse.zhu on 2024/8/28.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

var testClass =
#"""
@HandyCodable
public class Discount {
    /// 优惠券适用场景
    public struct UseScene: OptionSet, CaseIterable {
        public static var allCases: [UseScene] = [.pos, .scan, .delivery, .mall, .reservationEvent, .reservationMall]

        /// 门店POS
        public static let pos: UseScene = UseScene(rawValue: 1 << 0)
        /// 手机点单
        public static let scan: UseScene = UseScene(rawValue: 1 << 1)
        /// 手机外送
        public static let delivery: UseScene = UseScene(rawValue: 1 << 2)
        /// 商城
        public static let mall: UseScene = UseScene(rawValue: 1 << 3)
        /// 活动预约
        public static let reservationEvent: UseScene = UseScene(rawValue: 1 << 5)
        /// 预定商城
        public static let reservationMall: UseScene = UseScene(rawValue: 1 << 6)

        public typealias RawValue = Int

        public let rawValue: RawValue

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        public var name: String {
            switch self {
            case .pos:
                return "门店POS点单"
            case .scan:
                return "手机点单"
            case .delivery:
                return "手机外送"
            case .mall:
                return "商城"
            case .reservationEvent:
                return "活动预约"
            case .reservationMall:
                return "预定商城"
            default:
                return ""
            }
        }
    }

    public class DayLimit: HandyJSON {
        public var day: UInt8 = 0
        private var starTime: Int?
        public var startTime: Int = 0
        public var endTime: Int = 0

        public var weekDay: String {
            switch day {
            case 0:
                return "星期日"
            case 1:
                return "星期一"
            case 2:
                return "星期二"
            case 3:
                return "星期三"
            case 4:
                return "星期四"
            case 5:
                return "星期五"
            case 6:
                return "星期六"
            default:
                return ""
            }
        }

        public required init() {}

        public func didFinishMapping() {
            if let starTime = starTime {
                startTime = starTime
            }
        }
    }

    public class UseRuleProducts: HandyJSON {
        public var count: Int = 0
        public var ids: [Int] = [Int]()

        public required init() {}

        public func copy() -> UseRuleProducts {
            let useRuleProducts = UseRuleProducts()
            useRuleProducts.count = count
            useRuleProducts.ids = ids
            return useRuleProducts
        }
    }

    public static let FreeDiscountId: Int = -3
    public static let MEITUAN_TUANGOU: Int = -4
    public static let DOUYIN_TUANGOU: Int = -5
    public static let XHS_COUPON: Int = -6 // 小红书卡券
    public static let GiftCardCouponId: Int = 2000
    public static let GiftCardPhysicalCouponId: Int = 3000

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            cost <-- NSDecimalNumberTransform()
        mapper <<<
            val <-- NSDecimalNumberTransform()
        mapper <<<
            couponAmount <-- NSDecimalNumberTransform()
        mapper <<<
            couponAmountOffline <-- NSDecimalNumberTransform()
        mapper <<<
            validateTime <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss.SSS")
        mapper <<<
            invalidateTime <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss.SSS")
        mapper <<<
            category <-- EnumTransform()
        mapper <<<
            settleAmount <-- NSDecimalNumberTransform()
        mapper <<<
            requiredPrice <-- NSDecimalNumberTransform()
        mapper <<<
            useScene <-- TransformOf<UseScene, Int>(fromJSON: { rawVaule in
                if let rawVaule = rawVaule {
                    return UseScene(rawValue: rawVaule)
                }
                return nil
            }, toJSON: { useScene in
                useScene?.rawValue
            })
    }

    public var id: Int = -1 // ID, 识别Disocunt free：-3， MEITUAN_TUANGOU： -4, DOUYIN_TUANGOU: -5, XHS_COUPON: -6
    public var serverId: Int = -1 // 单品会员等级折扣用
    public var name: String = "" // 名字
    public var desc: String = "" // 描述
    public var usageDesc: String = "" // 描述
    public var type: String = "" // 类型, 参考BusiConst.DiscountType
    public var code: String = "" // 编码
    public var remark: String = "" // 备注
    public var isGiftCardCoupon: Bool = false // 是否是喝喝券
    public var cost: NSDecimalNumber = NSDecimalNumber.zero // 喝喝券成本
    public var category: BusiConst.DiscountCategory = BusiConst.DiscountCategory.NORMAL // 分类, 参考BusiConst.DiscountCategory
    public var val: NSDecimalNumber = NSDecimalNumber.zero // 值
    public var branchFlag: Int = 0 // 适用门店标示
    public var branchList: Array<Int> = [Int]() // 适用门店列表
    public var productFlag: Int = 0 // 适用单品标示
    public var levelDiscountProductList: [Int: [Double]] = [:] // 会员等级折扣适用不同商品，不同折扣   [商品Id：[折扣]]
    public var productList: Array<Int> = [Int]() // 适用单品列表
    public var optionList: [Int] = [] // 适用单品选项列表
    public var validateTime: Date? // 有效时间
    public var invalidateTime: Date? // 无效时间
    public var dayLimitData: [DayLimit]?
    public var discountRange: String = BusiConst.DiscountRange.BOTH.rawValue // 是否整单可用
    public var products: [Int] = [Int]() // 门店优惠适用商品
    /// 门店优惠是否全部门店可用
    public var global: Bool = false
    /// 优惠券适用场景
    public var useScene: UseScene?

    public var couponAmount: NSDecimalNumber = NSDecimalNumber.zero // 优惠券优惠金额（线上订单）
    public var couponAmountOffline: NSDecimalNumber = NSDecimalNumber.zero // 优惠券优惠金额（门店订单）
    public var noVipCard: Bool = false // 是否禁用会员余额支付
    public var useRuleType: String = "" // BusiConst.DiscountRuleType
    public var promotion: ActivityPromotion? // 当使用了促销活动时，在优惠券中保存促销活动，方便获取useProducts和giftProducts来发起下一次促销活动
    public var invoiceAmount: NSDecimalNumber = NSDecimalNumber.zero // 开票金额
    /** useRuleData */
    public var specNotFree: Bool = false // 规格默认不兑换   true: 优惠不包含规格加价  false：优惠包含规格加价
    public var favorNotFree: Bool = false // 口味默认不兑换  true: 优惠不包含口味加价  false：优惠包含口味加价
    public var options: [Int] = [] // 会员优惠适用规格列表
    /** 购买满足条件商品**/
    public var buyProducts: UseRuleProducts = UseRuleProducts()
    /** 满足条件后可优惠的商品**/
    public var giftProducts: UseRuleProducts = UseRuleProducts()
    /** 是否折高 */
    public var isDiscountHigh: Bool = false // true：折高；false：折低
    /** 是否可跨商品使用 */
    public var couponConditions: Bool = false // true：相同商品/不同商品都可用 ； false：仅用于相同商品
    /** end */
    /** 权益卡相关**/
    public var benefitCard: VipBenefitCard? // 关联的权益卡
    /** end**/
    /** 美团团购券相关 */
    public var settleAmount: NSDecimalNumber = NSDecimalNumber.zero // 美团团购券入账金额
    public var codes: [String] = [] // 如果同时使用多张券的话会把所有可用的券码放在这个数组里
    /** end**/
    /** 抖音券相关 */
    public var certificates: [Certificate] = Array<Certificate>() // 如果同时使用多张券的话会把所有可用的券码放在这个数组里
    public var verifyId: String = "" // 抖音次卡核销后返回的唯一值
    public var grouponType: Int = -1 // 1：兑换券；2：代金券；3：次卡
    /** end**/
    /** 价格策略相关**/
    public var productFirstDiscount: Bool = false // 是否首件优惠，ture只有第一件优惠，其他的不享受优惠
    /** end**/
    /** 满减券需要满足的金额 */
    public var requiredPrice: NSDecimalNumber = NSDecimalNumber.zero
    // 规格加价抵扣券适用规格id
    public var groupOptionId: Int = -1
    // 规格加价抵扣券适用规格组id
    public var groupId: Int = -1
    /**
     买赠券购买和赠送商品是否一致
     same:同商品
     diff:不同商品
     DiscountRuleGiftType
     **/
    public var giftType: String = ""

    public var bgColor: Int = 0xFF8700 // 背景色

    public var isRepeated: Bool = false // 是否可重复
    // MemoryData
    public var isTmp: Bool = false // 是否是临时折扣

    public var status: BusiConst.DiscountStatus = BusiConst.DiscountStatus.VALID // 使用状态

    public required init() {
    }
}
"""#

#if canImport(CodableWrapperMacros)
import CodableWrapperMacros

let testBigClass: [String: Macro.Type] = [
    "HandyCodable": HandyCodable.self,
]
#endif

final class HandyCodableBigClassTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testHandyCodable() throws {
//#if canImport(CodableWrapperMacros)
//        assertMacroExpansion(testClass,
//                             expandedSource: #"""
//struct HandyCodableModel {
//    var s: String = ""
//    var date: Date = Date()
//    var s2: String = ""
//    var s3: String = ""
//    var floa: float = 0.0
//    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            s <-- "s1"
//        mapper <<<
//            floa <-- ["float", "float1"]
//        mapper <<<
//            s3 <-- StringTransform()
//        mapper <<<
//            date <-- (["date", "date2"], DateTransform())
//        mapper <<<
//            s2 <-- ("s2", StringTransform())
//    }
//}
//extension HandyCodableModel: _HandyCodable { }
//"""#,
//macros: testMacros
//        )
//#else
//        XCTAssert(false, "CodableWrapperMacros not available")
//#endif
//    }
}
