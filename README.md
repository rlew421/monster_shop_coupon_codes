# Monster Shop Coupon Codes

## Background and Description

BE Mod 2 Week 5/5 Solo Project

Monster Shop is a fictional e-commerce application built using Rails v5.1.7. The application consists of merchants that list items for sale, users who can add items to their cart and checkout, orders that can be fulfilled by the merchants, and admins who have the ability to mimic functionality of other users. The application utilizes authorization and authentication to limit permissions to certain functionality based on user role. Merchants have full CRUD functionality over their items and registered users can create and update their user account.

## Getting Started

1. Clone this repository.

```
git clone git@github.com:rlew421/monster_shop_coupon_codes.git
```
2. Navigate into directory and run:

```
bundle install
```
3. Set up the databases:

```
rake db:{create,migrate,seed}
```
4. To run test suite:

```
rspec
```

## Schema Design

![image](https://user-images.githubusercontent.com/48839191/72415578-f285c680-3731-11ea-94f8-64fed5bab387.png)

## User Roles

1. Visitor - this type of user is anonymously browsing our site and is not logged in
1. Registered User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order
1. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out)
3. Merchant Admin - this user works for a merchant, and has additional capabilities than regular employees, such as changing merchant info.
3. Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work

## Order Status

1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled

## Heroku

[Link to Heroku App](https://mysterious-citadel-47242.herokuapp.com/)

## Coupon Codes

#### General Goals

Merchant users can generate coupon codes within the system.

#### Completion Criteria

1. Merchant users have a link on their dashboard to manage their coupons.
1. Merchant users have full CRUD functionality over their coupons with exceptions mentioned below:
   - merchant users cannot delete a coupon that has been used in an order
   - Note: Coupons cannot be for greater than 100% off.

1. A coupon will have a coupon name, a coupon code, and a percent-off value. The name and coupon code must be unique in the whole database. 
1. Users need a way to add a coupon code when checking out. Only one coupon may be used per order.
1. A coupon code from a merchant only applies to items sold by that merchant.


#### Implementation Guidelines

1. If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page. (This information should not be stored in the database until after checkout. )
1. The cart show page should calculate subtotals and the grand total as usual, but also show a "discounted total".
1. Users can enter different coupon codes until they finish checking out, then the last code entered before clicking checkout is final.
1. Order show pages should display which coupon was used, as well as the discounted price.

#### Extensions
1. Coupons can be used by multiple users, but may only be used one time per user.
1. Merchant users can enable/disable coupon codes
1. Merchant users can have a maximum of 5 coupons in the system

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

# Additional Extensions

## Bulk Discount

#### General Goals

Merchants add bulk discount rates for all of their inventory. These apply automatically in the shopping cart, and adjust the order_items price upon checkout.

#### Completion Criteria

1. Merchants need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
1. You can choose what type of bulk discount to implement: percentage based, or dollar based. For example:
   - 5% discount on 20 or more items
   - $10 off an order of $50 or more
1. A merchant can have multiple bulk discounts in the system.
1. When a user adds enough value or quantity of items to their cart, the bulk discount will automatically show up on the cart page.
1. A bulk discount from one merchant will only affect items from that merchant in the cart.
1. A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)

#### Implementation Guidelines

1. When an order is created during checkout, try to adjust the price of the items in the order_items table.

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- Advanced ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Merchant To-Do List

#### General Goals

Merchant dashboards will display a to-do list of tasks that need their attention.

#### Completion Criteria

1. Merchants should be shown a list of items which are using a placeholder image and encouraged to find an appropriate image instead; each item is a link to that item's edit form.
1. Merchants should see a statistic about unfulfilled items and the revenue impact. eg, "You have 5 unfulfilled orders worth $752.86"
1. Next to each order on their dashboard, Merchants should see a warning if an item quantity on that order exceeds their current inventory count.
1. If several orders exist for an item, and their summed quantity exceeds the Merchant's inventory for that item, a warning message is shown.

#### Implementation Guidelines

1. Make sure you are testing for all happy path and sad path scenarios.

#### Mod 2 Learning Goals reflected:

- MVC and Rails development
- Database relationships and migrations
- ActiveRecord
- Software Testing

# Rubric

| | **Feature Completeness** | **Rails** | **ActiveRecord** | **Testing and Debugging** | 
| --- | --- | --- | --- | --- |
| **4: Exceptional**  | One or more additional extension features complete. | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models | 
| **3: Passing** | Multiple address feature 100% complete, including all sad paths and edge cases | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. All preexisting tests still pass. |
| **2: Passing with Concerns** | One of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students utilize MVC to organize code, but cannot defend some of their design decisions. Or some functionality is not limited to the appropriately authorized users. | Ruby is used to process data that could use ActiveRecord instead. | Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective. | 
| **1: Failing** | More than one of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students do not effectively organize code using MVC. Or students do not authorize users. | Ruby is used to process data more often than ActiveRecord | Below 90% coverage for either features or models. | 

