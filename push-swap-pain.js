function init()
{
	addElements();
}

function addElements()
{
	const url = new URL(window.location.href);
	const urlSearch = new URLSearchParams(url.search);
	const numbers = urlSearch.get("nbr").split(",");
	const count = numbers.length;

	const stack1 = document.getElementById("stack1");

	numbers.forEach(n => {
		const newDiv = document.createElement("div");
		newDiv.classList.add("element");
		newDiv.style.width = (Number(n) + 1)/count * 100 + "%";
		newDiv.style.top = n * 4 + "px";
		stack1.appendChild(newDiv);
	});
}

function getCommands()
{
	const url = new URL(window.location.href);
	const urlSearch = new URLSearchParams(url.search);
	return urlSearch.get("cmd");
}

function applyCommand(cmd)
{
	switch (cmd)
	{
		case "a":


		break;
	}
	if(cmd == "a")
	{
		if()
	}
}

class Stack extends HTMLDivElement{
	private element: HTMLDivElement;

	constructor(id: string) {
		this.element = <HTMLDivElement>document.getElementById(id);
    }

    set innerHTML(content: string) {
        this.element.innerHTML = content;
    }

	swap() {
		document.getElementById()
	}
}
