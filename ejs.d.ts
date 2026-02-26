declare module "ejs" {
	const ejs: {
		render(
			template: string,
			data?: Record<string, unknown>,
			options?: Record<string, unknown>,
		): string;
	};

	export default ejs;
}
