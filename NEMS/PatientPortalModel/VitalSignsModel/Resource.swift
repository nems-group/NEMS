/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Resource : Codable {
	let resourceType : String?
	let id : String?
	let status : String?
	let effectiveDateTime : String?
	let component : [Component]?
	let code : Code?
	let category : Category?
	let subject : Subject?

	enum CodingKeys: String, CodingKey {

		case resourceType = "resourceType"
		case id = "id"
		case status = "status"
		case effectiveDateTime = "effectiveDateTime"
		case component = "component"
		case code = "code"
		case category = "category"
		case subject = "subject"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		effectiveDateTime = try values.decodeIfPresent(String.self, forKey: .effectiveDateTime)
		component = try values.decodeIfPresent([Component].self, forKey: .component)
		code = try values.decodeIfPresent(Code.self, forKey: .code)
		category = try values.decodeIfPresent(Category.self, forKey: .category)
		subject = try values.decodeIfPresent(Subject.self, forKey: .subject)
	}

}