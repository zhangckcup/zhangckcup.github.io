# JS教程·标准库·Object（阮一峰） 读书笔记

原文地址：[wangdoc.com/javascript/stdlib/object.html](https://wangdoc.com/javascript/stdlib/object.html)

## Object 对象

JavaScript 的所有其他对象都继承自`Object`对象，即那些对象都是`Object`的实例。

### Object()

```js
var obj = Object();
obj instanceof Object // true
```

`instanceof`运算符用来验证，一个对象是否为指定的构造函数的实例。`obj instanceof Object`返回`true`，就表示`obj`对象是`Object`的实例。

`Object`本身是一个函数，可以当作工具方法使用，将任意值转为对象。这个方法常用于保证某个值一定是对象:
1. 参数为空（或者为`undefined`和`null`），`Object()`返回一个空对象`{}`；
2. 如果参数是原始类型的值，`Object`方法将其转为对应的包装对象的实例；
3. 如果`Object`方法的参数是一个对象，它总是返回该对象，即不用转换。

利用第3点，可以写一个判断变量是否为对象的函数。
```js
function isObject(value) {
  return value === Object(value);
}

isObject([]) // true
isObject(true) // false
```

>注意，通过`var obj = new Object()`的写法生成新对象，与字面量的写法`var obj = {}`是等价的。或者说，后者只是前者的一种简便写法。

### Object 的静态方法

所谓“静态方法”，是指部署在`Object`对象自身的方法。

1. `Object.keys`方法的参数是一个对象，返回一个数组。该数组的成员都是该对象自身的（而不是继承的）所有属性名。
2. `Object.getOwnPropertyNames`方法与`Object.keys`类似，也是接受一个对象作为参数，返回一个数组，包含了该对象自身的所有属性名。
3. `Object.keys`方法只返回可枚举的属性（详见《对象属性的描述对象》一章），`Object.getOwnPropertyNames`方法还返回不可枚举的属性名。

```js
var a = ['Hello', 'World'];
Object.keys(a) // ["0", "1"]
Object.getOwnPropertyNames(a) // ["0", "1", "length"]
```

#### （1）对象属性模型的相关方法

* `Object.getOwnPropertyDescriptor()`：获取某个属性的描述对象。
* `Object.defineProperty()`：通过描述对象，定义某个属性。
* `Object.defineProperties()`：通过描述对象，定义多个属性。

#### （2）控制对象状态的方法

* `Object.preventExtensions()`：防止对象扩展。
* `Object.isExtensible()`：判断对象是否可扩展。
* `Object.seal()`：禁止对象配置。
* `Object.isSealed()`：判断一个对象是否可配置。
* `Object.freeze()`：冻结一个对象。
* `Object.isFrozen()`：判断一个对象是否被冻结。

#### （3）原型链相关方法

* `Object.create()`：该方法可以指定原型对象和属性，返回一个新的对象。
* `Object.getPrototypeOf()`：获取对象的Prototype对象。

### Object 的实例方法

* `valueOf`方法的作用是返回一个对象的“值”，默认情况下返回对象本身。
* `toString`方法的作用是返回一个对象的字符串形式，默认情况下返回类型字符串。（详见《数据类型转换》一章）

`Object.prototype.toString`方法返回对象的类型字符串，因此可以用来判断一个值的类型。

由于实例对象可能会自定义`toString`方法，覆盖掉`Object.prototype.toString`方法，所以为了得到类型字符串，最好直接使用`Object.prototype.toString`方法。通过函数的`call`方法，可以在任意值上调用这个方法，帮助我们判断这个值的类型。

```js
// 利用这个特性，可以写出一个比typeof运算符更准确的类型判断函数。
var type = function (o){
  var s = Object.prototype.toString.call(o);
  return s.match(/\[object (.*?)\]/)[1].toLowerCase();
};

// 在上面这个type函数的基础上，还可以加上专门判断某种类型数据的方法。
['Null', 'Undefined', 'Object', 'Array', 'String', 'Number', 'Boolean', 'Function', 'RegExp'
].forEach(function (t) {
  type['is' + t] = function (o) {
    return type(o) === t.toLowerCase();
  };
});
```

* `Object.prototype.toLocaleString`方法与`toString`的返回结果相同，也是返回一个值的字符串形式。这个方法的主要作用是留出一个接口，让各种不同的对象实现自己版本的`toLocaleString`，用来返回针对某些地域的特定的值。
* Object.prototype.hasOwnProperty方法接受一个字符串作为参数，返回一个布尔值，表示该实例对象自身是否具有该属性。

## 属性描述对象

JavaScript 提供了一个内部数据结构，用来描述对象的属性，控制它的行为，比如该属性是否可写、可遍历等等。这个内部数据结构称为“属性描述对象”（attributes object）。每个属性都有自己对应的属性描述对象，保存该属性的一些元信息。

下面是属性描述对象的一个例子。

```js
{
  value: 123,
  writable: false,
  enumerable: true,
  configurable: false,
  get: undefined,
  set: undefined
}
```

* `value`是该属性的属性值，默认为`undefined`;
* `writable`是一个布尔值，表示属性值（value）是否可改变（即是否可写），默认为`true`;
* `enumerable`是一个布尔值，表示该属性是否可遍历，默认为`true`。如果设为`false`，会使得某些操作（比如`for...in`循环、`Object.keys()`）跳过该属性;
* `configurable`是一个布尔值，表示可配置性，默认为`true`。如果设为`false`，将阻止某些操作改写该属性，比如无法删除该属性，也不得改变该属性的属性描述对象（`value`属性除外）。也就是说，`configurable`属性控制了属性描述对象的可写性;
* `get`是一个函数，表示该属性的取值函数（getter），默认为`undefined`;
* `set`是一个函数，表示该属性的存值函数（setter），默认为`undefined`。

### 属性描述对象相关方法

* `Object.getOwnPropertyDescriptor(obj, 'key')`方法可以获取属性描述对象。它的第一个参数是目标对象，第二个参数是一个字符串，对应目标对象的某个属性名。

>注意，`Object.getOwnPropertyDescriptor()`方法只能用于对象自身的属性，不能用于继承的属性。

* `Object.getOwnPropertyNames(obj)`方法返回一个数组，成员是参数对象自身的全部属性的属性名，不管该属性是否可遍历（与`Object.keys`相区别）。

>`Object.prototype`也是一个对象，所有实例对象都会继承它，它自身的属性都是不可遍历的。

* `Object.defineProperty()`方法允许通过属性描述对象，定义或修改一个属性，然后返回修改后的对象。

>如果一次性定义或修改多个属性，可以使用`Object.defineProperties()`方法。

```js
Object.defineProperty(object, propertyName: String, attributesObject)
Object.defineProperties(object, {key: attributesObject})

// 例.定义obj.p可以写成下面这样
var obj = Object.defineProperty({}, 'p', {
  value: 123,
  writable: false,
  enumerable: true,
  configurable: false
});

// 例.定义obj.p1-p3可以写成下面这样
var obj = Object.defineProperties({}, {
  p1: { value: 123, enumerable: true },
  p2: { value: 'abc', enumerable: true },
  p3: { get: function () { return this.p1 + this.p2 },
    enumerable:true,
    configurable:true
  }
});
```

* 实例对象的`propertyIsEnumerable()`方法返回一个布尔值，用来判断某个属性是否可遍历。注意，这个方法只能用于判断对象自身的属性，对于继承的属性一律返回`false`。

### 元属性

属性描述对象的各个属性称为“元属性”，因为它们可以看作是控制属性的属性。

#### 1. `value`属性是目标属性的值。

```js
// 通过value属性，读取或改写obj.p的例子
Object.getOwnPropertyDescriptor(obj, 'p').value
Object.defineProperty(obj, 'p', { value: 246 });
```

#### 2. `writable`属性是一个布尔值，决定了目标属性的值（value）是否可以被改变。

注意，正常模式下，对`writable`为`false`的属性赋值不会报错，只会默默失败。但是，严格模式下会报错，即使对属性重新赋予一个同样的值。

如果原型对象的某个属性的`writable`为`false`，那么子对象将无法自定义这个属性。

但是，有一个规避方法，就是通过覆盖属性描述对象，绕过这个限制。原因是这种情况下，原型链会被完全忽视。

```js
var proto = Object.defineProperty({}, 'foo', {
  value: 'a',
  writable: false
});

var obj = Object.create(proto);
Object.defineProperty(obj, 'foo', {
  value: 'b'
}); 
```

#### 3. enumerable（可遍历性）返回一个布尔值，表示目标属性是否可遍历。

JavaScript 的早期版本，`for...in`循环是基于`in`运算符的。我们知道，`in`运算符不管某个属性是对象自身的还是继承的，都会返回`true`。

`toString`不是`obj`对象自身的属性，但是`in`运算符也返回`true`，这导致了`toString`属性也会被`for...in`循环遍历。

这显然不太合理，后来就引入了“可遍历性”这个概念。只有可遍历的属性，才会被`for...in`循环遍历，同时还规定`toString`这一类实例对象继承的原生属性，都是不可遍历的，这样就保证了`for...in`循环的可用性。

具体来说，如果一个属性的enumerable为false，下面三个操作不会取到该属性:

* `for..in`循环
* `Object.keys`方法
* `JSON.stringify`方法

因此，enumerable可以用来设置“秘密”属性。


#### 4. configurable(可配置性）返回一个布尔值，决定了是否可以修改属性描述对象。

也就是说，configurable为false时，value、writable、enumerable和configurable都不能被修改了。

* `writable`: 只有在`false`改为`true`会报错，`true`改为`false`是允许的。
* `value`: 只要`writable`和`configurable`有一个为`true`，就允许改动。

## 存取器

除了直接定义以外，属性还可以用存取器（accessor）定义。其中，存值函数称为`setter`，使用属性描述对象的`set`属性；取值函数称为`getter`，使用属性描述对象的`get`属性。

```js
var obj = Object.defineProperty({}, 'p', {
  get: function () {
    return 'getter';
  },
  set: function (value) {
    console.log('setter: ' + value);
  }
});

var obj = {
  get p() {
    return 'getter';
  },
  set p(value) {
    console.log('setter: ' + value);
  }
};
```

注意，取值函数get不能接受参数，存值函数set只能接受一个参数（即属性的值）。

### 对象的拷贝

直接赋值，如果遇到存取器定义的属性，会只拷贝值。为了解决这个问题，我们可以通过Object.defineProperty方法来拷贝属性。

```js
var extend = function (to, from) {
  for (var property in from) {
    if (!from.hasOwnProperty(property)) continue;
    Object.defineProperty(
      to,
      property,
      Object.getOwnPropertyDescriptor(from, property)
    );
  }
  return to;
}
```

上面代码中，`hasOwnProperty`那一行用来过滤掉继承的属性，否则可能会报错，因为`Object.getOwnPropertyDescriptor`读不到继承属性的属性描述对象。

## 控制对象状态

有时需要冻结对象的读写状态，防止对象被改变。JavaScript 提供了三种冻结方法，最弱的一种是`Object.preventExtensions`，其次是`Object.seal`，最强的是`Object.freeze`。

1. `Object.preventExtensions`方法可以使得一个对象无法再添加新的属性。

>`Object.isExtensible`方法用于检查一个对象是否使用了`Object.preventExtensions`方法。也就是说，检查是否可以为一个对象添加属性。

2. `Object.seal`方法使得一个对象既无法添加新属性，也无法删除旧属性。

>`Object.seal`实质是把属性描述对象的`configurable`属性设为`false`，因此属性描述对象不再能改变了。
>
>`Object.seal`只是禁止新增或删除属性，并不影响**修改**某个属性的值。

>`Object.isSealed`方法用于检查一个对象是否使用了`Object.seal`方法。

3. `Object.freeze`方法可以使得一个对象无法添加新属性、无法删除旧属性、也无法改变属性的值，使得这个对象实际上变成了常量。

上面的三个方法锁定对象的可写性有一个漏洞：可以通过改变原型对象，来为对象增加属性。
