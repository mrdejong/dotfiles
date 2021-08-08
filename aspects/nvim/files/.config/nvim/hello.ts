// sample
class Hello {
	name: string;

	constructor(name: string) {
		this.name = name;
	}

	greet() {
		return "Hello, " + this.name;
	}
}

let b = new Hello("Hello");
b.greet();

let h = new Hello(b.name);

