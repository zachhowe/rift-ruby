rift-ruby
=========

**Under the MIT License**

Copyright (C) 2012 Zachary Howe

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

The goal of this project is to develop a complete interface for Trion World's RIFT Mobile App API. It is currently in a very primitive state.

**Requirements**:

* Ruby 1.9.2+
* Nokogiri gem
* JSON gem
* UUID gem

**Currently it can**:

* Authenticate and login
* List characeters on the account
* Look for available scratch off points
* Determine time remaining until next scratch off card (every hour you get a new one, accumulating up to only six at a time)
* Actually automate the scratch off process including: replaying and redeeming rewards. (Limited to the first type of scratch off, "Planar Rewards", aka "matchthree")

Although these features are planned, **currently it cannot**:

* Be run without a proxy (details further down this document)
* Be more supportive in case of an error and proper error handling
* Listen to guild chat
* Send messages to guild chat
* Do more scratch offs than the "Planar Rewards" scratch off type.

And maybe some other things, if I think of them.

In order this use this, you currently need a proxy to run through. I recommend Charles Web Debugging Proxy. This code will not currently run without a proxy. You will also need to enable SSL debugging for all domains and all ports with Charles.

---

Beyond that, here's how to use it in it's current state:

*If you have a RIFT Mobile Authenticator, it is not required for use of their API.*

The following command will list characters and their character IDs:

	ruby ./bin/rift_scratch_offs.rb [rift_email] [rift_password]

The following command will do 1 scratch off with the character ID provided:

	ruby ./bin/rift_scratch_offs.rb [rift_email] [rift_password] [character_id]

The following command will do all 6 scratch offs (or how many are left available) with the character ID provided:

	ruby ./bin/rift_scratch_offs.rb [rift_email] [rift_password] [character_id] 6
	
Keep in mind this project will be constantly evolving and could break with anything that Trion does with their API.

---

**Also, I am not in any way affiliated with Trion Worlds or RIFT**.
